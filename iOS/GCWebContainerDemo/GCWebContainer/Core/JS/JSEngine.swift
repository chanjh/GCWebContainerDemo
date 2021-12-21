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

    private func callJsString(_ javaScriptString: String, completionHandler: ((Any?, Error?) -> Void)?) {
        let runJSBlock = {
            self.webView.evaluateJavaScript(javaScriptString) { (obj, error) in
                completionHandler?(obj, error)
                guard let error = error else { return }
                print("evaluateJavaScript for \(self.webView.url?.absoluteString ?? "") fail. Error: \(error.localizedDescription)")
            }
        }
        if Thread.isMainThread {
            runJSBlock()
        } else {
            DispatchQueue.main.async {
                runJSBlock()
            }
        }
    }
}
