//
//  PDContextMenuManager.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/2/26.
//

import Foundation

class PDContextMenuManager: NSObject {
    static let shared: PDContextMenuManager = PDContextMenuManager()
    
    private var contextMenu: [MenuItem] = []
    
    override init() {
        super.init()
        BrowserManager.shared.addObserver(self)
    }

    func addMenu(id: String,
                 title: String,
                 senderId: String?,
                 action: @escaping GCWebView.MenuAction) {
        let menu = MenuItem(id: id,
                            title: title,
                            senderId: senderId,
                            action: action)
        let fn: GCWebView.MenuAction = { browser in
            action(browser)
            PDContextMenuManager.shared.onMenuClicked(in: browser, at: menu)
        }
        self.contextMenu.append(menu)
        BrowserManager.shared.pool.forEach {
            if let uiMenu = $0.makeMenuItem(uid: id,
                                            title: title,
                                            action: fn) {
                $0.contextMenu.addMenu(uiMenu)
            }
        }
    }
}

extension PDContextMenuManager: BrowserManagerObserver {
    @objc
    func browserManager(_ browserManager: BrowserManager,
                        didCreate webView: GCWebView?) {
        contextMenu.forEach { menu in
            let fn: GCWebView.MenuAction = { browser in
                menu.action(browser)
                PDContextMenuManager.shared.onMenuClicked(in: browser, at: menu)
            }
            if let uiMenu = webView?.makeMenuItem(uid: menu.id,
                                                  title: menu.title,
                                                  action: fn) {
                webView?.contextMenu.addMenu(uiMenu)
            }
        }
    }
    
    @objc
    func browserManager(_ browserManager: BrowserManager,
                        didRemove webView: GCWebView?) {
        
    }
}

fileprivate extension PDContextMenuManager {
    func onMenuClicked(in browser: GCWebView?, at menu: MenuItem) {
        var tab: [String: Any] = [:]
        if let browser = browser {
            tab["id"] = browser.identifier
        }
        if let pandora = PDManager.shared.pandoras.first(where: { $0.id == menu.senderId }) {
            let runners = PDManager.shared.findPandoraRunner(pandora)
            runners.forEach {
                let infoStr = ["menuItemId": menu.senderId].ext.toString() ?? "{}"
                let tabStr = tab.ext.toString() ?? "{}"
                $0.jsEngine?.eventCenter.publish("CONTEXTMENU_ONCLICKED",
                                                 arguments: [infoStr, tabStr],
                                                 completion: nil)
            }
        }
    }
    class MenuItem {
        open var id: String
        open var title: String
        open var senderId: String?
        open var action: GCWebView.MenuAction
        
        public init(id: String,
                    title: String,
                    senderId: String?,
                    action: @escaping GCWebView.MenuAction) {
            self.id = id
            self.title = title
            self.action = action
            self.senderId = senderId
        }
    }
}
