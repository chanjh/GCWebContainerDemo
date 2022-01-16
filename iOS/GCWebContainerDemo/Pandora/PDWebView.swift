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
    
    init(frame: CGRect = .zero, type: PDWebViewType = .content) {
        self.type = type
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func onInit() {
        super.onInit()
        _registerJSHandler()
        _injectAllContentJS()
    }
    
    private func _injectAllContentJS() {
        let contents = PDManager.shared.contentScripts
        contents?.forEach({
            // todo: inject time && main frame
            // todo: 如果是 popup page，不需要注入
            let userScript = WKUserScript(source: $0, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            addUserScript(userScript: userScript)
        })
    }
    
    private func _registerJSHandler() {
        jsServiceManager?.register(handler: TabsService(self))
        jsServiceManager?.register(handler: RuntimeService(self))
    }
}

extension PDWebView {
}
// todo: 这里需要感知一些生命周期
// 注入 contant js
