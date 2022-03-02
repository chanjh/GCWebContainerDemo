//
//  GCWebViewActionHandler.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/6.
//

import WebKit

// todo:
// 1. send event to jsservices
// 2. add observer

@objc protocol GCWebViewActionObserver: NSObjectProtocol {
    @objc optional func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    @objc optional func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
}
class GCWebViewActionHandler: NSObject {
    private weak var webView: GCWebView?
    var observers: NSHashTable<GCWebViewActionObserver> = NSHashTable(options: .weakMemory)
    
    init(webView: GCWebView) {
        self.webView = webView
    }
    
    func addObserver(_ observer: GCWebViewActionObserver) {
        observers.add(observer)
    }
    
    func removeObserver(_ observer: GCWebViewActionObserver) {
        observers.remove(observer)
    }
}

// MARK: - WKUIDelegate, WKNavigationDelegate
extension GCWebViewActionHandler: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        observers.allObjects.forEach { $0.webView?(webView, didFinish: navigation) }
    }
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        observers.allObjects.forEach { $0.webView?(webView,
//                                                   decidePolicyFor: navigationAction,
//                                                   decisionHandler: decisionHandler)}
        
        print("WebView decidePolicy for URL: \(navigationAction.request.url?.absoluteString ?? "")")
        decisionHandler(.allow)
    }
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
}
