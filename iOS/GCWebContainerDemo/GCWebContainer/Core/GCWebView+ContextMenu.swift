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
    typealias MenuAction = (GCWebView?) -> Swift.Void
    public func makeMenuItem(uid: String,
                             title: String,
                             action: @escaping MenuAction) -> UIMenuItem? {
        let targetClasses: [AnyClass] = [ type(of: self) ]
        if let aSelector = _makeSelector(uid: uid, classes: targetClasses, block: action) {
            return UIMenuItem(title: title, action: aSelector)
        }
        return nil
    }
    
    private func _makeSelector(uid: String, classes: [AnyClass], block: MenuAction?) -> Selector? {
        let selector = NSSelectorFromString(uid)
        let block = { [weak self] () -> Swift.Void in block?(self) }
        let castedBlock: AnyObject = unsafeBitCast(block as @convention(block) () -> Swift.Void, to: AnyObject.self)
        let imp = imp_implementationWithBlock(castedBlock)
        classes.forEach({ (cls) in
            if class_addMethod(cls, selector, imp, UnsafeMutablePointer(mutating: "v")) {
            } else { class_replaceMethod(cls, selector, imp, UnsafeMutablePointer(mutating: "v")) }
        })
        return selector
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
        
        func addMenu(_ menu: UIMenuItem) {
            self.items.append(menu)
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
