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
    func handle(params: Any?, serviceName: String, callback: String?) {
        guard let params = params as? [String: Any] else {
            return
        }
        if serviceName == JSServiceType.setContextMenu.rawValue {
            _handleSetContextMenu(params: params, callback: callback)
        } else if serviceName == JSServiceType.clearContextMenu.rawValue {
//            webView?.contextMenu.items = []
            webView?.jsEngine?.callFunction(callback!, params: ["id": "sssss"], completion: nil)
        }
    }

    private func _handleSetContextMenu(params: [String: Any], callback: String?) {
        
    }
}

extension ContextMenuService {
    struct MenuInfo {
        let text: String
        let id: String
    }
}

extension JSServiceType {
    static let setContextMenu   = JSServiceType("util.contextMenu.set")
    static let clearContextMenu = JSServiceType("util.contextMenu.clear")
}
