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
    
    func handle(message: JSServiceMessageInfo) {
        guard let params = message.params as? [String: Any] else {
            return
        }
        if message.serviceName == JSServiceType.setContextMenu.rawValue {
            _handleSetContextMenu(params: params, callback: message.callback)
        } else if message.serviceName == JSServiceType.clearContextMenu.rawValue {
//            webView?.contextMenu.items = []
            webView?.jsEngine?.callFunction(message.callback!, params: ["id": "sssss"], completion: nil)
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
