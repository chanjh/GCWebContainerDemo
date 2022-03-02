//
//  RFJSEngine.swift
//  ReadFlow
//
//  Created by Gill on 2020/1/27.
//  Copyright © 2020 陈嘉豪. All rights reserved.
//

import WebKit

// Native --> JS
class JSEngine: NSObject {
    let webView: GCWebView
    init(_ webView: GCWebView) {
        self.webView = webView
        super.init()
        webView.actionHandler.addObserver(self)
    }
    
    func callFunction(_ function: String,
                      arguments: [String],
                      completion: ((_ info: Any?, _ error: Error?) -> Void)? = nil) {
        var script = function + "("
        arguments.forEach { script += "\($0)," }
        script.removeLast()
        script += ")"
        callJsString(script, completionHandler: completion)
    }
    
    func callFunction(_ function: String,
                      params: [String: Any]? = nil,
                      completion: ((_ info: Any?, _ error: Error?) -> Void)? = nil) {
        var paramsStr: String?
        if let params = params {
            let paramsStrBeforeFix = params.ext.toString()
            paramsStr = JSServiceUtil.fixUnicodeCtrlCharacters(paramsStrBeforeFix ?? "")
        }
        let script = function + "(\(paramsStr ?? ""))"
        callJsString(script, completionHandler: completion)
    }
    
    private func callJsString(_ javaScriptString: String,
                              completionHandler: ((Any?, Error?) -> Void)?) {
        let runJS = {
            self.webView.evaluateJavaScript(javaScriptString) { (obj, error) in
                completionHandler?(obj, error)
                guard let error = error else { return }
                print(javaScriptString)
                print("evaluateJavaScript for \(self.webView.url?.absoluteString ?? "") fail. Error: \(error.localizedDescription)")
            }
        }
        
        runInMainThread(runJS)
    }
    
    // MARK: -
    func callFunction(_ function: String,
                      params: [String: Any]? = nil,
                      in frame: WKFrameInfo? = nil,
                      in contentWorld: WKContentWorld,
                      completion: ((Result<Any, Error>) -> Void)? = nil) {
        var paramsStr: String?
        if let params = params {
            let paramsStrBeforeFix = params.ext.toString()
            paramsStr = JSServiceUtil.fixUnicodeCtrlCharacters(paramsStrBeforeFix ?? "")
        }
        let script = function + "(\(paramsStr ?? ""))"
        callJsString(script, in: frame, in: contentWorld, completionHandler: completion)
    }
    
    private func callJsString(_ javaScriptString: String,
                              in frame: WKFrameInfo? = nil,
                              in contentWorld: WKContentWorld,
                              completionHandler: ((Result<Any, Error>) -> Void)? = nil) {
        let runJS = {
            self.webView.evaluateJavaScript(javaScriptString, in: frame, in: contentWorld) { result in
                completionHandler?(result)
                print(javaScriptString)
                print(result)
            }
        }
        
        runInMainThread(runJS)
    }
    
    private func runInMainThread(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }
}

extension JSEngine: GCWebViewActionObserver {
    
}
