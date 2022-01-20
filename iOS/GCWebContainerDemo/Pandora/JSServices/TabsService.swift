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
        if serviceName == JSServiceType.createTab.rawValue,
           let url = URL(string: params["url"] as? String ?? "") {
            (model as? BrowserModelConfig)?.tabManager.addTab(url)
        }
    }

}

extension JSServiceType {
    static let createTab   = JSServiceType("runtime.tabs.create")
}
