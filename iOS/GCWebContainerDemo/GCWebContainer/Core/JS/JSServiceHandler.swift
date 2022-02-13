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
    var navigator: WebContainerNavigator? { get }
}
protocol WebContainerNavigator {
    func openURL(_ options: OpenURLOptions)
}

struct OpenURLOptions {
    let url: URL
    let newTab: Bool = true
    let popup: Bool = false
}

class BaseJSService: NSObject {
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
    func handle(params: Any?, serviceName: String, callback: String?)
}
