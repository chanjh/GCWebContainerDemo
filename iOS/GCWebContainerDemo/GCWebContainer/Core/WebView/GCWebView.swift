//
//  GCWebView.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/4.
//

import WebKit

protocol GCWebViewInterface {
    func onInit();
    func willLoadRequest();
}

// todo delegate 系统
class GCWebView: WebView, GCWebViewInterface {
    private(set) var jsEngine: JSEngine?
    private(set) var jsServiceManager: JSServiceManager?
    private(set) var actionHandler: GCWebViewActionHandler!

    init(frame: CGRect = .zero) {
        let webViewConfiguration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        webViewConfiguration.userContentController = contentController
        super.init(frame: frame, configuration: webViewConfiguration)
        _initDelegates()
        _initContext()
        onInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _initDelegates() {
        self.actionHandler = GCWebViewActionHandler(webView: self)
        self.uiDelegate = actionHandler
        self.navigationDelegate = actionHandler
    }

    private func _initContext() {
        jsServiceManager = JSServiceManager(self)
        jsEngine = JSEngine(self)
    }
    
    func addUserScript(userScript: WKUserScript) {
        configuration.userContentController.addUserScript(userScript);
    }
    
    func onInit() { }
    func willLoadRequest() { }
}

extension GCWebView {
    override
    func load(_ request: URLRequest) -> WKNavigation? {
        willLoadRequest()
        return super.load(request)
    }
}
