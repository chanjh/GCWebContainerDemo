//
//  RuntimeService.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/2.
//

import Foundation

class RuntimeService: BaseJSService, JSServiceHandler {
    var handleServices: [JSServiceType] {
        return [.onPandoraInstalled,
                .runtimeGetPlatformInfo,
                .runtimeSendMessage,
                .runtimeSendResponse]
    }
    func handle(params: [String : Any], serviceName: String, callback: String?) {
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
                let runner = PDManager.shared.makeRunner(pandora)
                
                // todo: senderid
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
                let data: [String: Any] = ["param": params, "callback": callback ?? "", "senderId": senderId]
                let paramsStrBeforeFix = data.ext.toString()
                let paramsStr = JSServiceUtil.fixUnicodeCtrlCharacters(paramsStrBeforeFix ?? "")
                let onInstalledScript = "window.gc.bridge.eventCenter.publish('PD_EVENT_RUNTIME_ONMESSAGE', \(paramsStr));";
                
                runner.backgroundRunner?.evaluateJavaScript(onInstalledScript, completionHandler: nil)
            }
        } else if serviceName == JSServiceType.runtimeSendResponse.rawValue {
            let extensionId = params["extensionId"] as? String
            if let pandora = PDManager.shared.pandoras.first(where: { $0.id == extensionId }) {
                let runner = PDManager.shared.makeRunner(pandora)
                
                let data: [String: Any] = ["param": params]
                let paramsStrBeforeFix = data.ext.toString()
                let paramsStr = JSServiceUtil.fixUnicodeCtrlCharacters(paramsStrBeforeFix ?? "")
                let onInstalledScript = "\(callback ?? "")(\(paramsStr));";
                
                runner.backgroundRunner?.evaluateJavaScript(onInstalledScript, completionHandler: nil)
            }
        }
    }
}

extension JSServiceType {
    static let onPandoraInstalled = JSServiceType("runtime.onInstalled")
    static let runtimeSendMessage = JSServiceType("runtime.sendMessage")
    static let runtimeSendResponse　 = JSServiceType("runtime.sendResponse") // todo: 是不是可以合并这个 JSAPI
    static let runtimeGetPlatformInfo = JSServiceType("runtime.getPlatformInfo")
}
