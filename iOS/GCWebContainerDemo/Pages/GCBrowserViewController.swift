//
//  GCBrowserViewController.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/18.
//

import UIKit

class GCBrowserViewController: UIViewController {
    let webView: GCWebView
    
    init(webView: GCWebView? = nil) {
        if let wv = webView {
            self.webView = wv
        } else {
            self.webView = BrowserManager.shared.makeBrowser()
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.frame = CGRect(origin: CGPoint.zero, size: view.frame.size)
        view.addSubview(webView)
        webView.load(URLRequest(url: URL(string: "https://baidu.com")!))
    }
}
