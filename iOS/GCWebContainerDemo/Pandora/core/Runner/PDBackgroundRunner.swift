//
//  PDBackgroundRunner.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/2/10.
//

import WebKit

class PDBackgroundRunner: NSObject {
    private(set) var pandora: Pandora
    private(set) var webView: PDWebView?
    private(set) weak var serviceConfig: PDServiceConfigImpl?
    
    init(pandora: Pandora) {
        self.pandora = pandora
    }
    
    func run() -> PDWebView? {
        if let backgroundScript = pandora.background {
            _runBackgroundScript(backgroundScript)
        }
        return webView
    }
    
    // todo: 判断是否符合运行条件
    private func _runBackgroundScript(_ script: String) {
        let bgWebView = PDWebView(frame: CGRect(x: 0, y: 0, width: 1, height: 1),
                                  type: .background(pandora.id ?? ""))
        let serviceConfig = PDServiceConfigImpl(bgWebView)
        self.serviceConfig = serviceConfig
        self.webView = bgWebView
        bgWebView.model = serviceConfig
        bgWebView.ui = serviceConfig
        bgWebView.actionHandler.addObserver(self)
        bgWebView.pd_addChromeBridge()
        let userScript = WKUserScript(source: script,
                                      injectionTime: .atDocumentStart,
                                      forMainFrameOnly: true)
        bgWebView.addUserScript(userScript: userScript)
        // todo
        UIApplication.shared.keyWindow?.addSubview(bgWebView)
        bgWebView.loadHTMLString("<html></html>", baseURL: nil)
    }
}
// todo: 和 pop runner 统一代码
extension PDBackgroundRunner: GCWebViewActionObserver {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let data = ["type": "BACKGROUND", "id": pandora.id ?? "", "manifest": (pandora.manifest.raw ?? [:])] as [String : Any];
        let injectInfoScript = "window.chrome.__loader__";
        (webView as? PDWebView)?.jsEngine?.callFunction(injectInfoScript, params: data as [String : Any], completion: nil)
        
        let onInstalledScript = "window.gc.bridge.eventCenter.publish('PD_EVENT_RUNTIME_ONINSTALLED');";
        webView.evaluateJavaScript(onInstalledScript, completionHandler: nil)
    }
}
