//
//  TabsService.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/2.
//

import UIKit

class TabsService: BaseJSService, JSServiceHandler {
    var handleServices: [JSServiceType] {
        return [.createTab, .removeTab]
    }
    func handle(params: [String : Any], serviceName: String, callback: String?) {
        if serviceName == JSServiceType.createTab.rawValue,
           let url = URL(string: params["url"] as? String ?? "") {
            (model as? BrowserModelConfig)?.tabManager.addTab(url)
        } else if serviceName == JSServiceType.removeTab.rawValue {
            if let tabId = params["tabIds"] as? Int {
                (model as? BrowserModelConfig)?.tabManager.removeTabs([tabId])
            } else if let tabIds = params["tabIds"] as? [Int] {
                (model as? BrowserModelConfig)?.tabManager.removeTabs(tabIds)
            }
        }
    }

}

extension JSServiceType {
    static let createTab   = JSServiceType("runtime.tabs.create")
    static let removeTab   = JSServiceType("runtime.tabs.remove")
}
