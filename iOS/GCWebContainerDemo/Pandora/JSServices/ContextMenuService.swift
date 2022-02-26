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
        if message.serviceName == JSServiceType.setContextMenu.rawValue {
            _handleSetContextMenu(message: message, callback: message.callback)
        } else if message.serviceName == JSServiceType.clearContextMenu.rawValue {
        }
    }

    private func _handleSetContextMenu(message: JSServiceMessageInfo, callback: String?) {
        guard let params = message.params as? [String: Any] else {
            return
        }
        let id = params["id"] as? String ?? UUID().uuidString
        let title = params["title"] as? String ?? ""
        let onClick = params["onclickCallback"] as? String // 通过框架处理过的 callback 参数
        
        if let selector = makeSelector(id: id, message: message, callback: onClick) {
            let menu = GCWebView.MenuItem(id: id, title: title, action: selector)
            PDContextMenuManager.shared.addMenu(menu)
        }
    }
    
    private func makeSelector(id: String, message: JSServiceMessageInfo, callback: String?) -> Selector? {
        let action: () -> Void = { [weak self] () in
            guard let `self` = self else { return }
            // todo params
            if let callback = callback {
                self.webView?.jsEngine?.callFunction(callback, params: [:], completion: nil)
            }
            // todo contextmenu onclick
            guard let params = message.params as? [String: Any] else {
                return
            }
            
            var extensionId = params["extensionId"] as? String
            if extensionId == nil {
                let pdWebView = (self.webView as? PDWebView)
                switch pdWebView?.type {
                case .popup(let id):
                    extensionId = id
                case .background(let id):
                    extensionId = id
                case .content:
                    extensionId = message.contentWorld.name
                case .none :
                    ()
                }
            }
            if let pandora = PDManager.shared.pandoras.first(where: { $0.id == extensionId }) {
                let runners = PDManager.shared.findPandoraRunner(pandora)
                runners.forEach {
                    let data: [String: Any] = ["info": ["menuItemId": id], "tab": [:]]
                    let paramsStrBeforeFix = data.ext.toString()
                    let paramsStr = JSServiceUtil.fixUnicodeCtrlCharacters(paramsStrBeforeFix ?? "")
                    let onMsgScript = "window.gc.bridge.eventCenter.publish('PD_EVENT_CONTEXTMENU_ONCLICKED', \(paramsStr));";

                    $0.evaluateJavaScript(onMsgScript, completionHandler: nil)
                }
            }
        }
        return addSelector(uid: id, classes: [type(of: self), type(of: webView ?? NSObject())], block: action)
        
    }
    
    public func addSelector(uid: String, classes: [AnyClass], block: (() -> Swift.Void)?) -> Selector? {
        let selector = NSSelectorFromString(uid)
        let block = { () -> Swift.Void in block?() }
        let castedBlock: AnyObject = unsafeBitCast(block as @convention(block) () -> Swift.Void, to: AnyObject.self)
        let imp = imp_implementationWithBlock(castedBlock)
        classes.forEach({ (cls) in
            if class_addMethod(cls, selector, imp, UnsafeMutablePointer(mutating: "v")) {
            } else { class_replaceMethod(cls, selector, imp, UnsafeMutablePointer(mutating: "v")) }
        })
        return selector
    }
}

extension ContextMenuService {
    @objc func test() {
        
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

struct OnClickedData {
    let chekced: Bool?
    let editable: Bool
    let frameId: Int?
    let frameUrl: String?
    let linkUrl: String?
    let mediaType: String?
    let menuItemId: Any? // (String|Int) https://stackoverflow.com/questions/41063722/in-swift-can-you-constrain-a-generic-to-two-types-string-and-int
    let pageUrl: String?
    let parentMenuItemId: Any? // string | int
    let selectionText: String?
    let srcUrl: String?
    let wasChecked: Bool?
    
    func toMap() -> [String: Any] {
        return [:]
    }
}
