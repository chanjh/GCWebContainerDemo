//
//  PDWebView.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/6.self.type = type
//

import WebKit

enum PDWebViewType {
    case content;
    case background(String);
    case popup(String);
}

class PDWebView: GCWebView {
    let type: PDWebViewType;
    
    init(frame: CGRect = .zero,
         type: PDWebViewType = .content,
         model: WebContainerModelConfig? = nil,
         ui: WebContainerUIConfig? = nil) {
        self.type = type
        super.init(frame: frame, model: model, ui: ui)
    }
    
    init(frame: CGRect = .zero,
         type: PDWebViewType = .content,
         serviceConfig: PDServiceConfigImpl) {
        self.type = type
        super.init(frame: frame, model: serviceConfig, ui: serviceConfig)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func onInit() {
        super.onInit()
        actionHandler.addObserver(self)
        _registerJSHandler()
        _injectAllContentJS()
    }
    
    private func _injectAllContentJS() {
        pd_addChromeBridge()
        let contents = PDManager.shared.contentScripts
        contents?.forEach({
            // todo: inject time && main frame
            // todo: 如果是 popup page，不需要注入
            let userScript = WKUserScript(source: $0, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            addUserScript(userScript: userScript)
        })
    }
    
    private func _registerJSHandler() {
        jsServiceManager?.register(handler: TabsService(self, ui: ui, model: model))
        jsServiceManager?.register(handler: RuntimeService(self, ui: ui, model: model))
    }
}

extension PDWebView: GCWebViewActionObserver {
    // todo
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        let data = ["type": "BACKGROUND", "id": pandora.id ?? "", "manifest": (pandora.manifest.raw ?? [:])] as [String : Any];
//        let injectInfoScript = "window.chrome.__loader__";
//        bgRunner?.jsEngine?.callFunction(injectInfoScript, params: data as [String : Any], completion: nil)
//
//        let onInstalledScript = "window.gc.bridge.eventCenter.publish('PD_EVENT_RUNTIME_ONINSTALLED');";
//        bgRunner?.evaluateJavaScript(onInstalledScript, completionHandler: nil)
    }
}
// todo: 这里需要感知一些生命周期
// 注入 contant js
