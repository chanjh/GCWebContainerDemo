//
//  PDServiceConfigImpl.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/20.
//

import Foundation
import UIKit

class PDServiceConfigImpl: BrowerTabManagerInterface {
    
    private let pdWebView: PDWebView
    init(_ webView: PDWebView) {
        self.pdWebView = webView
    }
    
    func addTab(_ url: URL?) {
        // todo
        let nav = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        let browser = nav?.topViewController as? BrowserViewController
        browser?.didAddUrl(url)
    }
    
    func removeTabs(_ tabs: [Int]) {
        tabs.forEach { id in
            TabsManager.shared.remove(id)
        }
    }
}

extension PDServiceConfigImpl: WebContainerUIConfig,
                               BrowserModelConfig {
    var webView: GCWebView { pdWebView }
    var tabManager: BrowerTabManagerInterface { self }
    var navigator: WebContainerNavigator? { self }
}

extension PDServiceConfigImpl: WebContainerNavigator {
    func openURL(_ options: OpenURLOptions) {
        if options.newTab {
            addTab(options.url)
        }
    }
}
