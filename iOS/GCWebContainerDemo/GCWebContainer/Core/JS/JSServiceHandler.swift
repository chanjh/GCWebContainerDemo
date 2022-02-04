//
//  JSServiceHandler.swift
//  ReadFlow
//
//  Created by Gill on 2020/1/27.
//  Copyright © 2020 陈嘉豪. All rights reserved.
//

import Foundation
protocol WebContainerModelConfig: AnyObject { }
protocol WebContainerUIConfig: AnyObject {
    var webView: GCWebView { get }
}

class BaseJSService {
    weak var webView: GCWebView?
    weak var ui: WebContainerUIConfig?
    weak var model: WebContainerModelConfig?
    init(_ webView: GCWebView,
         ui: WebContainerUIConfig?,
         model: WebContainerModelConfig?) {
        self.webView = webView
        self.ui = ui
        self.model = model
    }
}

protocol JSServiceHandler {
    var handleServices: [JSServiceType] { get }
    // todo: params 支持 any 类型？
    func handle(params: [String: Any], serviceName: String, callback: String?)
}

//protocol JSService
