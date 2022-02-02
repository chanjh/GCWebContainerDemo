//
//  TabsManager.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/27.
//

import Foundation

enum TabStatus {
    
}

class TabRemoveInfo: NSObject {
    let isWindowClosing: Bool;
    let windowId: Bool;
    init(isWindowClosing: Bool, windowId: Bool) {
        self.isWindowClosing = isWindowClosing
        self.windowId = windowId
        super.init()
    }
}
class TabChangeInfo: NSObject {
    let audible: Bool? = nil
    let autoDiscardable: Bool? = nil
    let discarded: Bool? = nil
    let favIconUrl: String? = nil
    let groupId: Int? = nil
    let mutedInfo: TabMutedInfo? = nil
    let pinned: Bool? = nil
    let status: TabStatus? = nil
    let title: String? = nil
    let url: String? = nil
    override init() { }
}

struct TabMutedInfo {
    enum Reason {
        case user;
        case capture;
        case `extension`;
    }
    let extensionId: String?
    let muted: Bool
    let reason: Reason?
}

@objc protocol TabsManagerListerner: NSObjectProtocol {
    // Fires when the active tab in a window changes
    func onActivated(tabId: Int);
    // Fired when a tab is updated.
    func onUpdated(tabId: Int, changeInfo: TabChangeInfo);
    // Fired when a tab is closed.
    func onRemoved(tabId: Int, removeInfo: TabRemoveInfo);
}

class TabsManager {
    static let shared = TabsManager()
    
    private var pool: [GCWebView] = [];
    
    var count: Int { return pool.count }
    
    private var observers: NSHashTable<TabsManagerListerner> = NSHashTable(options: .weakMemory)
    
    func addObserver(_ observer: TabsManagerListerner) {
        observers.add(observer)
    }
    
    func removeObserver(_ observer: TabsManagerListerner) {
        observers.remove(observer)
    }
    
    func makeBrowser(model: WebContainerModelConfig? = nil,
                     ui: WebContainerUIConfig? = nil) -> GCWebView {
        let webView = BrowserManager.shared.makeBrowser(model: model, ui: ui)
        pool.append(webView)
        return webView
    }
    
    func title(at index: Int) -> String? {
        return pool[index].url?.relativeString ?? "\(index)"
    }
    
    func browser(at index: Int) -> GCWebView? {
        return pool[index]
    }
    
    func browser(for identifier: Int) -> GCWebView? {
        return pool.first { $0.identifier == identifier }
    }
    
    func remove(_ webView: GCWebView) {
        pool.removeAll { $0 == webView }
    }
    func remove(_ identifier: Int) {
        pool.removeAll { $0.identifier == identifier }
    }
}
