//
//  PDWebView.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/6.
//

import WebKit

class PDWebView: GCWebView {
    override func onInit() {
        super.onInit()
        _registerJSHandler()
        _injectAllContentJS()
    }
    
    private func _injectAllContentJS() {
        let contents = PDManager.shared.contentScripts
        contents?.forEach({
            // todo: inject time && main frame
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
