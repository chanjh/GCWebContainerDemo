//
//  PDRunner.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/19.
//

import Foundation
import WebKit

class PDRunner: NSObject {
    var pandora: Pandora
    private var bgRunner: GCWebView?
    init(pandora: Pandora) {
        self.pandora = pandora
    }
    
    func run() {
//        pandora.run()
        if let backgroundScript = pandora.background {
            runBackgroundScript(backgroundScript)
        }
    }
    
    // todo: 判断是否符合运行条件
    func runBackgroundScript(_ script: String) {
        let bgWebView = GCWebView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        bgWebView.pd_addChromeBridge()
        let userScript = WKUserScript(source: script,
                                      injectionTime: .atDocumentStart,
                                      forMainFrameOnly: true)
        bgWebView.addUserScript(userScript: userScript)
        bgRunner = bgWebView
        bgWebView.navigationDelegate = self
        // todo
        UIApplication.shared.keyWindow?.addSubview(bgWebView)
        bgRunner?.loadHTMLString("<html></html>", baseURL: nil)
    }
    
    func runContentScript(target: GCWebView?) {
        guard let target = target else {
            return
        }
        // find content script
        
    }
    
    func runPageAction() -> GCWebView {
        let bgWebView = GCWebView()
        bgWebView.pd_addChromeBridge()
        bgWebView.navigationDelegate = self
        bgRunner = bgWebView
        return bgWebView;
//        bgRunner?.loadHTMLString(pandora.manifest.action?["default_popup"], baseURL: Bundle.main.bundleURL)
    }
    
    func runBrowserAction() {
        
    }
}

extension PDRunner: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let data = ["type": "BACKGROUND", "id": pandora.id ?? "", "manifest": (pandora.manifest.raw ?? [:])] as [String : Any];
        let injectInfoScript = "window.chrome.__loader__";
        bgRunner?.jsEngine?.callFunction(injectInfoScript, params: data as [String : Any], completion: nil)
        
        let onInstalledScript = "window.gc.bridge.eventCenter.publish('PD_EVENT_RUNTIME_ONINSTALLED');";
        bgRunner?.evaluateJavaScript(onInstalledScript, completionHandler: nil)
    }
}

private extension GCWebView {
    func pd_addChromeBridge() {
        if let path  = Bundle.main.path(forResource: "chrome", ofType: "js"),
           let chrome = try? String(contentsOfFile: path) {
            let userScript = WKUserScript(source: chrome,
                                          injectionTime: .atDocumentStart,
                                          forMainFrameOnly: true)
            configuration.userContentController.addUserScript(userScript)
        }
    }
}
