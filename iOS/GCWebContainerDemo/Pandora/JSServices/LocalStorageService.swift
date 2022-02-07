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

    func handle(params: Any?, serviceName: String, callback: String?) {
        guard let params = params as? [String: Any] else {
            return
        }
        if serviceName == JSServiceType.localStorageSet.rawValue {
            params.forEach { LocalStorage.shared.set($1, forKey: $0) }
        } else if serviceName == JSServiceType.localStorageGet.rawValue {
            if let keys = params["keys"] as? [String], let callback = callback {
                let obj = keys.compactMap { LocalStorage.shared.object(forKey: $0) }
                webView?.jsEngine?.callFunction(callback, arguments: obj, completion: nil)
            } else if let key = params["keys"] as? String, let callback = callback {
                if let obj = LocalStorage.shared.object(forKey: key) {
                    webView?.jsEngine?.callFunction(callback, arguments: obj, completion: nil)
                }
            }
        } else if serviceName == JSServiceType.localStorageClear.rawValue {
            LocalStorage.shared.clear()
        }
    }
}

extension JSServiceType {
    static let localStorageSet = JSServiceType("storage.local.set")
    static let localStorageGet = JSServiceType("storage.local.get")
    static let localStorageClear = JSServiceType("storage.local.clear")
}
