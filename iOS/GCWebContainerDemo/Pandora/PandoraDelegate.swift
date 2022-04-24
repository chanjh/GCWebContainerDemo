//
//  PandoraDelegate.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/4/18.
//

import Foundation
import GCWebContainer

protocol PandoraDelegate {
    var runnerDelegate: PandoraRunnerDelegate? { get }
    var bookMark: IPandoraBookmark? { get }
    var storage: IPandoraStorage? { get }
//    var contextMenu: IPandoraContextMenu? { get }
    var tabsManager: IPandoraTabsManager? { get }
}

extension PandoraDelegate {
    var runnerDelegate: PandoraRunnerDelegate? { nil }
    var bookMark: IPandoraBookmark? { nil }
    var storage: IPandoraStorage? { nil }
//    var contextMenu: IPandoraContextMenu? { nil }
    var tabsManager: IPandoraTabsManager? { nil }
}

protocol PandoraRunnerDelegate: WebContainerNavigator { }

//protocol IPandoraContextMenu { }

protocol IPandoraTabsManager {
    var pool: [PDWebView] { get }
    func addObserver(_ observer: PDTabsEventListerner)
    func removeObserver(_ observer: PDTabsEventListerner)
    func tabInfo(in identifier: Int) -> Tab?
    func webView(in identifier: Int) -> PDWebView?
    func remove(tab identifier: Int)
}

protocol IPandoraBookmark {
    
}

protocol IPandoraStorage {
    func set(_ object: Any, forKey key: String)
    func object(forKey key: String) -> Any?
    func clear()
}

@objc protocol PDTabsEventListerner: NSObjectProtocol {
    // Fires when the active tab in a window changes
    func onActivated(tabId: Int);
    // Fired when a tab is updated.
    func onUpdated(tabId: Int, changeInfo: TabChangeInfo);
    // Fired when a tab is closed.
    func onRemoved(tabId: Int, removeInfo: TabRemoveInfo);
}

class Tab {
    var active: Bool? = nil
    var audible: Bool? = nil
    var autoDiscardable: Bool? = nil
    var discarded: Bool? = nil
    var favIconUrl: String? = nil
    var groupId: Int? = nil
    var height: Int? = nil
    var highlighted: Bool? = nil
    var id: Int? = nil
    var incognito: Bool? = nil // todo, 不是可选
    var index: Int? = nil // todo, 不是可选
    var mutedInfo: Any? = nil; // todo
    var openerTabId: Int? = nil
    var pendingUrl: String? = nil
    var pinned: Bool? = nil // todo, 不是可选
    var sessionId: String? = nil
    var status: TabStatus? = nil
    var title: String? = nil
    var url: String? = nil
    var windowId: Int? = nil // todo, 不是可选
    var width: Int? = nil
    weak var webView: PDWebView?
    
    func toMap() -> Dictionary<String, Any> {
        return ["id": "\(id ?? 0)"];
    }
    
    init(id: Int? ) {
        self.id = id
    }
}

class TabRemoveInfo: NSObject {
    let isWindowClosing: Bool;
    let windowId: Bool;
    init(isWindowClosing: Bool, windowId: Bool) {
        self.isWindowClosing = isWindowClosing
        self.windowId = windowId
        super.init()
    }
    func toString() -> String {
        return "{}"
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

enum TabStatus {
    
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
