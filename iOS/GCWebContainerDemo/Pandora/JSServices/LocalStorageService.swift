//
//  LocalStorageService.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/2/4.
//

import Foundation

class LocalStorageService: BaseJSService, JSServiceHandler {
    var handleServices: [JSServiceType] {
        return [.localStorageSet, .localStorageGet, .localStorageClear]
    }

    func handle(message: JSServiceMessageInfo) {
        guard let params = message.params as? [String: Any] else {
            return
        }
        if message.serviceName == JSServiceType.localStorageSet.rawValue {
            params.forEach { LocalStorage.shared.set($1, forKey: $0) }
            if let callback = message.callback {
                webView?.jsEngine?.callFunction(callback)
            }
        } else if message.serviceName == JSServiceType.localStorageGet.rawValue {
            if let keys = params["keys"] as? [String], let callback = message.callback {
                let obj = keys.compactMap { LocalStorage.shared.object(forKey: $0) }
                webView?.jsEngine?.callFunction(callback, params: ["result": obj], completion: nil)
            } else if let key = params["keys"] as? String, let callback = message.callback {
                if let obj = LocalStorage.shared.object(forKey: key) {
                    webView?.jsEngine?.callFunction(callback, params: ["result": obj], completion: nil)
                }
            }
        } else if message.serviceName == JSServiceType.localStorageClear.rawValue {
            LocalStorage.shared.clear()
            if let callback = message.callback {
                webView?.jsEngine?.callFunction(callback)
            }
        }
    }
}

extension JSServiceType {
    static let localStorageSet = JSServiceType("storage.local.set")
    static let localStorageGet = JSServiceType("storage.local.get")
    static let localStorageClear = JSServiceType("storage.local.clear")
}
