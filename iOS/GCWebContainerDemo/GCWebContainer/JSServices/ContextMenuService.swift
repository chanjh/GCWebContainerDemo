//
//  Service.swift
//  ReadFlow
//
//  Created by Gill on 2020/1/27.
//  Copyright © 2020 陈嘉豪. All rights reserved.
//

import UIKit

class ContextMenuService: BaseJSService, JSServiceHandler {
    var handleServices: [JSServiceType] {
        return [.setContextMenu, .clearContextMenu]
    }
    func handle(params: [String : Any], serviceName: String, callback: String?) {
        if serviceName == JSServiceType.setContextMenu.rawValue {
            _handleSetContextMenu(params: params, callback: callback)
        } else if serviceName == JSServiceType.clearContextMenu.rawValue {
//            webView?.contextMenu.items = []
        }
    }

    private func _handleSetContextMenu(params: [String: Any], callback: String?) {
        guard let menus = params["menu"] as? [[String: String]], let webView = webView else { return }
        var menuItems = [UIMenuItem]()
        menus.forEach { (menu) in
            guard let text = menu["text"], let id = menu["id"] else { return }
            let action: () -> Void = { [weak self] () in
                guard let self = self, let callback = callback else { return }
//                self.webView?.jsEngine?.callFunction(callback, params: ["id": id], completion: nil)
            }
//            menuItems.append(webView.wkMenuItem(uid: id, title: text, action: action))
        }
//        webView.contextMenu.items = menuItems
    }
}


extension ContextMenuService {
    struct MenuInfo {
        let text: String
        let id: String
    }
}
