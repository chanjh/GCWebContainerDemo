//
//  PDRunner.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/19.
//

import Foundation
import WebKit

class PDRunner {
    let pandora: Pandora
    private var bgRunner: GCWebView?
    init(pandora: Pandora) {
        self.pandora = pandora
    }
    
    func run() {
        if let backgroundScript = pandora.background {
            runBackgroundScript(backgroundScript)
        }
    }
    
    func runBackgroundScript(_ script: String) {
        let bgWebView = GCWebView()
        bgWebView.pd_addChromeBridge()
        let userScript = WKUserScript(source: script,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: true)
        bgWebView.addUserScript(userScript: userScript)
        bgRunner = bgWebView
        bgRunner?.loadHTMLString("<html></html>", baseURL: nil)
    }
    
    func runContentScript(_ script: String) {
        
    }
    
    func runPageAction() {
        
    }
    
    func runBrowserAction() {
        
    }
}

private extension GCWebView {
    func pd_addChromeBridge() {
        if let path  = Bundle.main.path(forResource: "chrome", ofType: "js"),
           let chrome = try? String(contentsOfFile: path) {
            let userScript = WKUserScript(source: chrome,
                                          injectionTime: .atDocumentStart,
                                          forMainFrameOnly: true)
            configuration.userContentController.addUserScript(userScript)
        }
    }
}
