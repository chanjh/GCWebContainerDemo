//
//  PDContentRunner.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/2/10.
//

import WebKit

class PDContentRunner {
    weak var webView: GCWebView?
    private(set) var pandoras: [Pandora] = []
    
    init(_ webView: GCWebView) {
        self.webView = webView
    }
    
    func run() {
        PDManager.shared.loaders.forEach { loader in
            if let pandora = loader.pandora {
                pandoras.append(pandora)
                let contentWorld = WKContentWorld.world(name: pandora.pdName)
                // - chrome.js
                if let path  = Bundle.main.path(forResource: "chrome", ofType: "js"),
                   let chrome = try? String(contentsOfFile: path) {
                    let userScript = WKUserScript(source: chrome,
                                                  injectionTime: .atDocumentStart,
                                                  forMainFrameOnly: true,
                                                  in: contentWorld)
                    
                    webView?.addUserScript(userScript: userScript)
                }
                // - manifest info
                _injectManifest(pandora)
                // - webkit.messageHandler
                if let jsManager = webView?.jsServiceManager {
                    webView?.configuration.userContentController.add(jsManager,
                                                                     contentWorld: contentWorld,
                                                                     name: JSServiceManager.scriptMessageName)
                }
                if let contentScripts = pandora.manifest.contentScripts {
                    contentScripts.forEach { scriptInfo in
                        scriptInfo.js?.forEach({ js in
                            if let content = loader.fileContent(at: js) {
                                let userScript = WKUserScript(source: content,
                                                              injectionTime: .atDocumentEnd,
                                                              forMainFrameOnly: true,
                                                              in: contentWorld)
                                webView?.addUserScript(userScript: userScript)
                            }
                        })
                    }
                }
            }
        }
    }
    
    private func _injectManifest(_ pandora: Pandora) {
        let data = ["type": "CONTENT", "id": pandora.id ?? "", "manifest": (pandora.manifest.raw ?? [:])] as [String : Any];
        let injectInfoScript = "window.chrome.__loader__";
        let paramsStrBeforeFix = data.ext.toString()
        let paramsStr = JSServiceUtil.fixUnicodeCtrlCharacters(paramsStrBeforeFix ?? "")
        let script = injectInfoScript + "(\(paramsStr))"
        let contentWorld = WKContentWorld.world(name: pandora.pdName)
        let userScript = WKUserScript(source: script,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: true,
                                      in: contentWorld)
        webView?.addUserScript(userScript: userScript)
    }
}
