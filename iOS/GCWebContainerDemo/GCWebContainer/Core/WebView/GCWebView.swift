//
//  GCWebView.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/4.
//

import WebKit

class GCWebView: WebView {
    private(set) var jsEngine: JSEngine?
    private(set) var jsServiceManager: JSServiceManager?

    // todo: 不在初始化时注入, 改在其他生命周期
    init() {
        let webViewConfiguration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
//        let js = script ?? GCWebView._getBridgeScript()
//        let userScript = WKUserScript(source: js,
//                                      injectionTime: .atDocumentStart,
//                                      forMainFrameOnly: true)
//        contentController.addUserScript(userScript)
        webViewConfiguration.userContentController = contentController
        super.init(frame: .zero, configuration: webViewConfiguration)
        _initContext()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func _initContext() {
        jsServiceManager = JSServiceManager(self)
        jsEngine = JSEngine(self)
        // todo: delete
        jsServiceManager?.register(handler: ContextMenuService(self))
    }
    
    func addUserScript(userScript: WKUserScript) {
        configuration.userContentController.addUserScript(userScript);
    }
}

extension GCWebView {
    static func _getBridgeScript() -> String {
        guard let path = Bundle.main.path(forResource: "jsbridge", ofType: "js") else {
            return ""
        }
        do {
            return try String(contentsOfFile: path)
        } catch {
            return ""
        }
    }
}
