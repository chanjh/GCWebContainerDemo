//
//  RuntimeService.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/2.
//

import Foundation

class RuntimeService: BaseJSService, JSServiceHandler {
    var handleServices: [JSServiceType] {
        return [.runtimeGetPlatformInfo,
                .runtimeSendMessage,
                .runtimeSendResponse,
                .runtimeOpenOptionsPage]
    }
    func handle(params: Any?, serviceName: String, callback: String?) {
        guard let params = params as? [String: Any] else {
            return
        }
        if serviceName == JSServiceType.runtimeGetPlatformInfo.rawValue,
            let callback = callback {
            let platformInfo = [
                "arch": "", // todo: https://developer.chrome.com/docs/extensions/reference/runtime/#type-PlatformOs
                "nacl_arch": "",
                "os": "mac", // NOTE: Return mac
            ]
            webView?.jsEngine?.callFunction(callback, params: platformInfo, completion: nil)
        } else if serviceName == JSServiceType.runtimeSendMessage.rawValue {
            let extensionId = params["extensionId"] as? String
            if let pandora = PDManager.shared.pandoras.first(where: { $0.id == extensionId }) {
                let runners = PDManager.shared.findPandoraRunner(pandora)
                runners.forEach {
                    // todo: senderid
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
                    // todo: 是 param 还是 message
                    let data: [String: Any] = ["param": params, "callback": callback ?? "", "senderId": senderId]
                    let paramsStrBeforeFix = data.ext.toString()
                    let paramsStr = JSServiceUtil.fixUnicodeCtrlCharacters(paramsStrBeforeFix ?? "")
                    let onMsgScript = "window.gc.bridge.eventCenter.publish('PD_EVENT_RUNTIME_ONMESSAGE', \(paramsStr));";
                    
                    $0.evaluateJavaScript(onMsgScript, completionHandler: nil)
                }
            }
        } else if serviceName == JSServiceType.runtimeSendResponse.rawValue {
            let extensionId = params["extensionId"] as? String
            if let pandora = PDManager.shared.pandoras.first(where: { $0.id == extensionId }) {
                let runners = PDManager.shared.findPandoraRunner(pandora)
                runners.forEach {
                    let data: [String: Any] = ["param": params]
                    let paramsStrBeforeFix = data.ext.toString()
                    let paramsStr = JSServiceUtil.fixUnicodeCtrlCharacters(paramsStrBeforeFix ?? "")
                    let sendResponseScript = "\(callback ?? "")(\(paramsStr));";
                    
                    $0.evaluateJavaScript(sendResponseScript, completionHandler: nil)
                }
            }
        } else if serviceName == JSServiceType.runtimeOpenOptionsPage.rawValue {
            let pdWebView = (webView as? PDWebView)
            var senderId = ""
            switch pdWebView?.type {
            case .popup(let id):
                senderId = id
            case .background(let id):
                senderId = id
            case .content, .none:
                ()
            }
            if senderId.count > 0,
               let pandora = PDManager.shared.pandoras.first(where: { $0.id == senderId }),
                let optionURL = pandora.optionPageFilePath {
                // todo: open_in_tab
                ui?.navigator?.openURL(OpenURLOptions(url: optionURL))
            }
        }
    }
}

extension JSServiceType {
    static let runtimeSendMessage = JSServiceType("runtime.sendMessage")
    static let runtimeSendResponse = JSServiceType("runtime.sendResponse") // todo: 是不是可以合并这个 JSAPI
    static let runtimeGetPlatformInfo = JSServiceType("runtime.getPlatformInfo")
    static let runtimeOpenOptionsPage = JSServiceType("runtime.openOptionsPage")
}
