//
//  BrowserManager.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/18.
//

import Foundation
import ObjectiveC

class BrowserManager {
    private var pool: [GCWebView] = [];
    
    static let shared = BrowserManager()
    
    var count: Int {
        return pool.count
    }
    
    func makeBrowser() -> GCWebView {
        let webView = GCWebView()
        webView.identifier = UUID().uuidString
        pool.append(webView)
        return webView
    }
    
    func title(at index: Int) -> String? {
        return "\(index)"
    }
    
    func browser(at index: Int) -> GCWebView? {
        return pool[index]
    }
    
    func browser(at identifier: String) -> GCWebView? {
        return pool.first { $0.identifier == identifier }
    }
    
    func remove(_ webView: GCWebView) {
        pool.removeAll { $0 == webView }
    }
    func remove(_ identifier: String) {
        pool.removeAll { $0.identifier == identifier }
    }
}

private var kGCWebViewIDKey: UInt8 = 0
extension GCWebView {
    var identifier: String? {
        get {
            return objc_getAssociatedObject(self, &kGCWebViewIDKey) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kGCWebViewIDKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
