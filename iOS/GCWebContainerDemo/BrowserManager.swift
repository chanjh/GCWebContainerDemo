//
//  BrowserManager.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/18.
//

import Foundation

class BrowserManager {
    private var pool: [GCWebView] = [];
    
    static let shared = BrowserManager()
    
    var count: Int {
        return pool.count
    }
    
    func makeBrowser() -> GCWebView {
        let webView = GCWebView()
        pool.append(webView)
        return webView
    }
    
    func title(at index: Int) -> String? {
        return "\(index)"
    }
    
    func browser(at index: Int) -> GCWebView? {
        return pool[index]
    }
}

