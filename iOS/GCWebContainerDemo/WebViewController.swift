//
//  WebViewController.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/9.
//

import WebKit

class WebViewController: UIViewController {
    let webView: GCWebView = GCWebView();
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.frame = view.frame
        view.addSubview(webView)
    }
}
