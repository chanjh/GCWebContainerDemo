//
//  PDRunner.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/19.
//

import Foundation
import WebKit

class PDRunner: NSObject, WKNavigationDelegate {
    var pandora: Pandora
    private var bgRunner: GCWebView?
    init(pandora: Pandora) {
        self.pandora = pandora
    }
    
    func run() {
        pandora.run()
        if let backgroundScript = pandora.background {
            runBackgroundScript(backgroundScript)
        }
    }
    
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
    
    func runContentScript(_ script: String) {
        
    }
    
    func runPageAction() {
        
    }
    
    func runBrowserAction() {
        
    }
}

extension PDRunner: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didfinish")
        DispatchQueue.main.asyncAfter(deadline: .now()+2) { [weak self] in
            // todo
            let data = ["type": "BACKGROUND", "id": "12222"];
            let injectInfoScript = "window.chrome.__loader__";
            self?.bgRunner?.jsEngine?.callFunction(injectInfoScript, params: data, completion: { info, error in
                print("completion")
                print("\(info)")
                print("\(error)")
            })
            let onInstalledScript = "window.gc.bridge.eventCenter.publish('PD_EVENT_RUNTIME_ONINSTALLED', {});";
            self?.bgRunner?.evaluateJavaScript(onInstalledScript, completionHandler: nil)
        }
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
