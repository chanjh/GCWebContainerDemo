//
//  BrowserManager.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/18.
//

import Foundation
import ObjectiveC

class BrowserManager {
    static let shared = BrowserManager()
    
    private var pool: [PDWebView] = [];
    
    var count: Int { return pool.count }
    
    func makeBrowser(model: WebContainerModelConfig? = nil,
                     ui: WebContainerUIConfig? = nil) -> PDWebView {
        let webView = PDWebView(frame: .zero, type: .content, model: model, ui: ui)
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
