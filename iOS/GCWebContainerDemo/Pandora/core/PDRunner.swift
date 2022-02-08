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
    private var bgRunner: PDWebView?
    private var serviceConfig: PDServiceConfigImpl?
    
    var backgroundRunner: PDWebView? {
        return bgRunner
    }
    
    init(pandora: Pandora) {
        self.pandora = pandora
    }
    
    func run() {
        if let backgroundScript = pandora.background {
            runBackgroundScript(backgroundScript)
        }
    }
    
    // todo: 判断是否符合运行条件
    func runBackgroundScript(_ script: String) {
        let bgWebView = PDWebView(frame: CGRect(x: 0, y: 0, width: 1, height: 1),
                                  type: .background(pandora.id ?? ""))
        let serviceConfig = PDServiceConfigImpl(bgWebView)
        self.serviceConfig = serviceConfig
        bgWebView.model = serviceConfig
        bgWebView.ui = serviceConfig
        bgWebView.actionHandler.addObserver(self)
        bgWebView.pd_addChromeBridge()
        let userScript = WKUserScript(source: script,
                                      injectionTime: .atDocumentStart,
                                      forMainFrameOnly: true)
        bgWebView.addUserScript(userScript: userScript)
        bgRunner = bgWebView
        // todo
        UIApplication.shared.keyWindow?.addSubview(bgWebView)
        bgRunner?.loadHTMLString("<html></html>", baseURL: nil)
    }
    
    func runPageAction() -> PDWebView {
        let pageWebView = PDWebView(frame: .zero,
                                  type: .popup(pandora.id ?? ""))
        let serviceConfig = PDServiceConfigImpl(pageWebView)
        self.serviceConfig = serviceConfig
        pageWebView.model = serviceConfig
        pageWebView.ui = serviceConfig
        pageWebView.actionHandler.addObserver(self)
        pageWebView.pd_addChromeBridge()
        bgRunner = pageWebView
        return pageWebView;
    }
    
    func runBrowserAction() {
        
    }
}

extension PDRunner: GCWebViewActionObserver {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let data = ["type": "BACKGROUND", "id": pandora.id ?? "", "manifest": (pandora.manifest.raw ?? [:])] as [String : Any];
        let injectInfoScript = "window.chrome.__loader__";
        bgRunner?.jsEngine?.callFunction(injectInfoScript, params: data as [String : Any], completion: nil)
        
        let onInstalledScript = "window.gc.bridge.eventCenter.publish('PD_EVENT_RUNTIME_ONINSTALLED');";
        bgRunner?.evaluateJavaScript(onInstalledScript, completionHandler: nil)
    }
}

extension GCWebView {
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
