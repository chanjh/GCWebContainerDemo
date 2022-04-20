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
    
    private weak var _ui: WebContainerUIConfig?
    private weak var _model: WebContainerModelConfig?
    var ui: WebContainerUIConfig? {
        set { _onAddUIConfig(newValue) }
        get { _ui }
    }
    var model: WebContainerModelConfig? {
        set { _onAddModelConfig(newValue) }
        get { _model }
    }
    
    init(frame: CGRect = .zero,
         model: WebContainerModelConfig? = nil,
         ui: WebContainerUIConfig? = nil,
         configuration: WKWebViewConfiguration = WKWebViewConfiguration()) {
        super.init(frame: frame, configuration: configuration)
        self.model = model
        self.ui = ui
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
    private func _onAddModelConfig(_ model: WebContainerModelConfig?) {
        guard let model = model else { return }
        _model = model
        jsServiceManager?.handlers.forEach({
            if let jsService = $0 as? BaseJSService {
                jsService.model = model
            }
        })
    }
    
    private func _onAddUIConfig(_ ui: WebContainerUIConfig?) {
        guard let ui = ui else { return }
        _ui = ui
        jsServiceManager?.handlers.forEach({
            if let jsService = $0 as? BaseJSService {
                jsService.ui = ui
            }
        })
    }
}
