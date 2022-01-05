//
//  RuntimeService.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/2.
//

import Foundation

class RuntimeService: BaseJSService, JSServiceHandler {
    var handleServices: [JSServiceType] {
        return [.onPandoraInstalled, .runtimeGetPlatformInfo]
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
        }
    }
}

extension JSServiceType {
    static let onPandoraInstalled = JSServiceType("runtime.onInstalled")
    static let runtimeGetPlatformInfo = JSServiceType("runtime.getPlatformInfo")
}
