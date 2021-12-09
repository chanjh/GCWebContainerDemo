//
//  JSServiceHandler.swift
//  ReadFlow
//
//  Created by Gill on 2020/1/27.
//  Copyright © 2020 陈嘉豪. All rights reserved.
//

import Foundation

class BaseJSService {
    weak var webView: GCWebView?
    init(_ webView: GCWebView) {
        self.webView = webView
    }
}

protocol JSServiceHandler {
    var handleServices: [JSServiceType] { get }
    func handle(params: [String: Any], serviceName: String, callback: String?)
}
