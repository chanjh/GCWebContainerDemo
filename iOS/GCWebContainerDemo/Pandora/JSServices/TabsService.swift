//
//  TabsService.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/2.
//

import UIKit

class TabsService: BaseJSService, JSServiceHandler {
    var handleServices: [JSServiceType] {
        return [.createTab]
    }
    func handle(params: [String : Any], serviceName: String, callback: String?) {
//        webView?.jsEngine?.callFunction(callback!, params: ["id": "sssss"], completion: nil)
    }

}

extension JSServiceType {
    static let createTab   = JSServiceType("runtime.tabs.create")
}
