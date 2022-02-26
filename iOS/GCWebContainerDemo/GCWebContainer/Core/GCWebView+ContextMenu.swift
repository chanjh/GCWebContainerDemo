//
//  GCWebView+ContextMenu.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/2/17.
//

import WebKit

extension GCWebView {
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return contextMenu.items.contains { $0.action == action }
        || super.canPerformAction(action, withSender: sender)
    }
}

extension GCWebView {
    public var contextMenu: ContextMenu {
        set { objc_setAssociatedObject(self, &GCWebView.contextMenuKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        get {
            guard let value = objc_getAssociatedObject(self, &GCWebView.contextMenuKey) as? ContextMenu else {
                let obj = ContextMenu()
                self.contextMenu = obj
                return obj
            }
            return value
        }
    }
    private static var contextMenuKey: UInt8 = 0
    
    public class ContextMenu {
        public private(set) var items = [UIMenuItem]() {
            didSet {
                UIMenuController.shared.menuItems = self.items
            }
        }
        
        func addMenu(_ menu: MenuItem) {
            let item = UIMenuItem(title: menu.title, action: menu.action)
            self.items.append(item)
        }
        
        func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            return true
        }
    }
}

extension GCWebView {
    public class MenuItem {
        open var id: String
        open var title: String
        open var action: Selector
        
        public init(id: String, title: String, action: Selector) {
            self.id = id
            self.title = title
            self.action = action
        }
    }
}
