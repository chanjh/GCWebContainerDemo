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
    override
    func load(_ request: URLRequest) -> WKNavigation? {
        if let url = request.url,
           url.scheme == PDURLSchemeHandler.scheme {
            let document = try? FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false)
            let unzip = "file://\(document?.path ?? "")/\(PDFileManager.unzipPath)/"
            let res = url.absoluteString.replacingOccurrences(of: "\(PDURLSchemeHandler.scheme)://", with: unzip, options: .literal, range: nil)
            if let fileUrl = URL(string: res), let unzipUrl = URL(string: unzip),
               let pandora = PDManager.shared.pandoras.first(where: { $0.id == url.host }) {
                let runner = PDManager.shared.makeBrowserActionRunner(pandora: pandora,
                                                                      webView: self as? PDWebView)
                runner.run()
                willLoadRequest()
                return loadFileURL(fileUrl, allowingReadAccessTo: unzipUrl)
            }
        }
        willLoadRequest()
        return super.load(request)
    }
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
