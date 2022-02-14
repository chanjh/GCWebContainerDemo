//
//  TabsService.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/2.
//

import UIKit

class TabsService: BaseJSService, JSServiceHandler {
    var handleServices: [JSServiceType] {
        return [.createTab, .removeTab, .queryTab, .tabSendMessage]
    }
    
    override init(_ webView: GCWebView, ui: WebContainerUIConfig?, model: WebContainerModelConfig?) {
        super.init(webView, ui: ui, model: model)
        TabsManager.shared.addObserver(self)
    }
    
    func handle(params: Any?, serviceName: String, callback: String?) {
        guard let params = params as? [String: Any] else {
            return
        }
        
        if serviceName == JSServiceType.createTab.rawValue,
           let url = URL(string: params["url"] as? String ?? "") {
            (model as? BrowserModelConfig)?.tabManager.addTab(url)
        } else if serviceName == JSServiceType.removeTab.rawValue {
            if let tabId = params["tabIds"] as? Int {
                (model as? BrowserModelConfig)?.tabManager.removeTabs([tabId])
            } else if let tabIds = params["tabIds"] as? [Int] {
                (model as? BrowserModelConfig)?.tabManager.removeTabs(tabIds)
            }
        } else if serviceName == JSServiceType.queryTab.rawValue {
            
        } else if serviceName == JSServiceType.tabSendMessage.rawValue {
            guard let tabId = params["tabId"] as? Int else {
                return
            }
            
            let runners = PDManager.shared.contentScriptRunners
            runners.forEach {
                if let id = $0.webView?.identifier, tabId == id {
                    let message = params["message"]
                    
                    let pdWebView = (webView as? PDWebView)
                    var senderId = ""
                    switch pdWebView?.type {
                    case .popup(let id):
                        senderId = id
                    case .background(let id):
                        senderId = id
                    case .content:
                        senderId = "\(webView?.identifier ?? 0)"
                    case .none:
                        ()
                    }
                    let data: [String: Any] = ["param": message ?? {}, "callback": callback ?? "", "senderId": senderId]
                    let paramsStrBeforeFix = data.ext.toString()
                    let paramsStr = JSServiceUtil.fixUnicodeCtrlCharacters(paramsStrBeforeFix ?? "")
                    let onMsgScript = "window.gc.bridge.eventCenter.publish('PD_EVENT_RUNTIME_ONMESSAGE', \(paramsStr));";
                    
                    $0.webView?.evaluateJavaScript(onMsgScript, completionHandler: nil)
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
