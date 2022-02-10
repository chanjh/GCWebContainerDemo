//
//  PDContentRunner.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/2/10.
//

import WebKit

class PDContentRunner {
    weak var webView: GCWebView?
    
    init(_ webView: GCWebView) {
        self.webView = webView
    }
    
    func run() {
        let contents = PDManager.shared.contentScripts
        contents?.forEach({
            // todo: inject time && main frame
            // todo: 如果是 popup page，不需要注入
            let userScript = WKUserScript(source: $0, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            webView?.addUserScript(userScript: userScript)
        })
    }
}
