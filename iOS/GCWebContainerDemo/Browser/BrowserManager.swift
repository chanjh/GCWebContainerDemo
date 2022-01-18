//
//  BrowserManager.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/18.
//

import Foundation
import ObjectiveC

class BrowserManager {
    private var pool: [PDWebView] = [];
    
    static let shared = BrowserManager()
    
    var count: Int {
        return pool.count
    }
    
    func makeBrowserController(url: URL?) -> BrowserViewController {
        return BrowserViewController(url: url)
    }
    
    func makeBrowser() -> PDWebView {
        let webView = PDWebView()
        webView.identifier = UUID().uuidString
        pool.append(webView)
        return webView
    }
    
    func title(at index: Int) -> String? {
        return pool[index].url?.relativeString ?? "\(index)"
    }
    
    func browser(at index: Int) -> PDWebView? {
        return pool[index]
    }
    
    func browser(at identifier: String) -> PDWebView? {
        return pool.first { $0.identifier == identifier }
    }
    
    func remove(_ webView: PDWebView) {
        pool.removeAll { $0 == webView }
    }
    func remove(_ identifier: String) {
        pool.removeAll { $0.identifier == identifier }
    }
}

private var kGCWebViewIDKey: UInt8 = 0
extension PDWebView {
    var identifier: String? {
        get {
            return objc_getAssociatedObject(self, &kGCWebViewIDKey) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kGCWebViewIDKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
