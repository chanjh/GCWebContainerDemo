//
//  BrowserBaseJSService.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/18.
//

import Foundation

protocol BrowerTabManagerInterface {
    func addTab(_ url: URL?)
    func removeTabs(_ tabs: [Int])
}

protocol BrowserModelConfig: WebContainerModelConfig {
    var tabManager: BrowerTabManagerInterface { get }
}

class BrowserBaseJSService: BaseJSService {
    init(_ webView: GCWebView,
         ui: WebContainerUIConfig?,
         model: BrowserModelConfig?) {
        super.init(webView, ui: ui, model: model)
    }
}
