//
//  PDServiceConfigImpl.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/20.
//

import Foundation
import UIKit

class PDServiceConfigImpl: WebContainerUIConfig,
                           BrowserModelConfig,
                           BrowerTabManagerInterface {
    private let pdWebView: PDWebView
    init(_ webView: PDWebView) {
        self.pdWebView = webView
    }
    
    var webView: GCWebView { pdWebView }
    
    var tabManager: BrowerTabManagerInterface { self }
    
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
