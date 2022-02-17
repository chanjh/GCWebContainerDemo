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
    
    func run() {
        _prepareBackgroundWebView()
        _injectManifest()
        
        if let backgroundScript = pandora.background {
            _runBackgroundScript(backgroundScript)
        } else if let backgroundScripts = pandora.backgrounds {
            backgroundScripts.forEach { _runBackgroundScript($0) }
        }
    }
    
    private func _prepareBackgroundWebView() {
        let bgWebView = PDWebView(frame: CGRect(x: 0, y: 0, width: 1, height: 1),
                                  type: .background(pandora.id ?? ""))
        let serviceConfig = PDServiceConfigImpl(bgWebView)
        self.serviceConfig = serviceConfig
        self.webView = bgWebView
        bgWebView.model = serviceConfig
        bgWebView.ui = serviceConfig
        bgWebView.actionHandler.addObserver(self)
        bgWebView.pd_addChromeBridge()
        // todo
        UIApplication.shared.keyWindow?.addSubview(bgWebView)
        // todo：不能只是单纯的 HTML
        if let path  = Bundle.main.path(forResource: "background", ofType: "html"),
           let url = URL(string: "file://\(path)")  {
            bgWebView.loadFileURL(url, allowingReadAccessTo: url)
        }
    }
    
    // todo: 判断是否符合运行条件
    private func _runBackgroundScript(_ script: String) {
        let userScript = WKUserScript(source: script,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: true)
        webView?.addUserScript(userScript: userScript)
    }
    
    private func _injectManifest() {
        let data = ["type": "BACKGROUND", "id": pandora.id ?? "", "manifest": (pandora.manifest.raw ?? [:])] as [String : Any];
        let injectInfoScript = "window.chrome.__loader__";
        let paramsStrBeforeFix = data.ext.toString()
        let paramsStr = JSServiceUtil.fixUnicodeCtrlCharacters(paramsStrBeforeFix ?? "")
        let script = injectInfoScript + "(\(paramsStr))"
        _runBackgroundScript(script)
    }
    
    
    private func _onInstall() {
        let onInstalledScript = "window.gc.bridge.eventCenter.publish('PD_EVENT_RUNTIME_ONINSTALLED');"
        _runBackgroundScript(onInstalledScript)
    }
}
// todo: 和 pop runner 统一代码
extension PDBackgroundRunner: GCWebViewActionObserver {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        let data = ["type": "BACKGROUND", "id": pandora.id ?? "", "manifest": (pandora.manifest.raw ?? [:])] as [String : Any];
//        let injectInfoScript = "window.chrome.__loader__";
//        (webView as? PDWebView)?.jsEngine?.callFunction(injectInfoScript, params: data as [String : Any], completion: nil)
//
//        let onInstalledScript = "window.gc.bridge.eventCenter.publish('PD_EVENT_RUNTIME_ONINSTALLED');";
//        webView.evaluateJavaScript(onInstalledScript, completionHandler: nil)
    }
}
