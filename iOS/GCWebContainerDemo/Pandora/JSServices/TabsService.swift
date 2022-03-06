//
//  TabsService.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/2.
//

import UIKit
import WebKit

class TabsService: BaseJSService, JSServiceHandler {
    var handleServices: [JSServiceType] {
        return [.createTab, .removeTab, .queryTab, .tabSendMessage]
    }
    
    override init(_ webView: GCWebView, ui: WebContainerUIConfig?, model: WebContainerModelConfig?) {
        super.init(webView, ui: ui, model: model)
        TabsManager.shared.addObserver(self)
    }
    
    func handle(message: JSServiceMessageInfo) {
        guard let params = message.params as? [String: Any] else {
            return
        }
        
        if message.serviceName == JSServiceType.createTab.rawValue,
           let url = URL(string: params["url"] as? String ?? "") {
            if let tab = (model as? BrowserModelConfig)?.tabManager.addTab(url),
                let callback = message.callback {
                webView?.jsEngine?.callFunction(callback,
                                                params: tab.toMap(),
                                                in: nil,
                                                in: message.contentWorld, completion: nil)
            }
        } else if message.serviceName == JSServiceType.removeTab.rawValue {
            if let tabId = params["tabIds"] as? Int {
                (model as? BrowserModelConfig)?.tabManager.removeTabs([tabId])
            } else if let tabIds = params["tabIds"] as? [Int] {
                (model as? BrowserModelConfig)?.tabManager.removeTabs(tabIds)
            }
        } else if message.serviceName == JSServiceType.queryTab.rawValue {
            
        } else if message.serviceName == JSServiceType.tabSendMessage.rawValue {
            let tabId = params["tabId"] as? Int
            let runners = PDManager.shared.contentScriptRunners
            runners.forEach { runner in
                if let tabId = tabId,
                    runner.webView?.identifier != tabId {
                    return
                }
                let arguments = params["message"] ?? {}
                let senderId = findSenderId(on: message) ?? ""
                let data: [String: Any] = ["param": arguments, "callback": message.callback ?? "", "senderId": senderId]
                let paramsStrBeforeFix = data.ext.toString()
                let paramsStr = JSServiceUtil.fixUnicodeCtrlCharacters(paramsStrBeforeFix ?? "")
                let onMsgScript = "window.gc.bridge.eventCenter.publish('PD_EVENT_RUNTIME_ONMESSAGE', \(paramsStr));";
                runner.pandoras.forEach {
                    let contentWorld = WKContentWorld.world(name: $0.id)
                    runner.webView?.evaluateJavaScript(onMsgScript,
                                                       in: nil,
                                                       in: contentWorld,
                                                       completionHandler: { result in
                        print(result)
                    })
                }
            }
        }
    }
}

extension TabsService: TabsManagerListerner {
    func onActivated(tabId: Int) {
        
    }
    func onUpdated(tabId: Int, changeInfo: TabChangeInfo) {
        
    }
    func onRemoved(tabId: Int, removeInfo: TabRemoveInfo) {
        let params = "{tabId: \(tabId), removeInfo: \(removeInfo.toString())}"
        let onRemovedScript = "window.gc.bridge.eventCenter.publish('PD_EVENT_TABS_ONREMOVED', \(params));";
        webView?.evaluateJavaScript(onRemovedScript, completionHandler: nil)        
    }
}

extension JSServiceType {
    static let createTab   = JSServiceType("runtime.tabs.create")
    static let removeTab   = JSServiceType("runtime.tabs.remove")
    static let queryTab   = JSServiceType("runtime.tabs.query")
    static let tabSendMessage   = JSServiceType("runtime.tabs.sendMessage")
}
