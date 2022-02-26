//
//  PDContextMenuManager.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/2/26.
//

import Foundation

class PDContextMenuManager: NSObject {
    static let shared: PDContextMenuManager = PDContextMenuManager()
    
    private(set) var contextMenu: [GCWebView.MenuItem] = []
    
    override init() {
        super.init()
        BrowserManager.shared.addObserver(self)
    }
    
    func addMenu(_ item: GCWebView.MenuItem) {
        self.contextMenu.append(item)
        BrowserManager.shared.pool.forEach {
            $0.contextMenu.addMenu(item)
        }
    }
}

extension PDContextMenuManager: BrowserManagerObserver {
    @objc
    func browserManager(_ browserManager: BrowserManager,
                        didCreate webView: GCWebView?) {
        contextMenu.forEach { webView?.contextMenu.addMenu($0) }
    }
    
    @objc
    func browserManager(_ browserManager: BrowserManager,
                        didRemove webView: GCWebView?) {
        
    }
}
