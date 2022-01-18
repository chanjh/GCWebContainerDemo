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
//        if serviceName == JSServiceType.createTab.rawValue,
//           let viewController = webView?.next as? UIViewController {
//            let browserVC = BrowserManager.shared.makeBrowserController(url: URL(string: "https://qq.com"))
//            viewController.navigationController?.pushViewController(browserVC, animated: true)
//        }
    }

}

extension JSServiceType {
    static let createTab   = JSServiceType("runtime.tabs.create")
}
