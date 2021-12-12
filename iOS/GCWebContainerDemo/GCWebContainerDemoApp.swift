//
//  GCWebContainerDemoApp.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/7.
//

import SwiftUI
import WebKit

struct WebViewStr : UIViewRepresentable {
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView  {
        return GCWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
}

@main
struct GCWebContainerDemoApp: App {
    var body: some Scene {
        WindowGroup {
            WebViewStr(request: URLRequest.init(url: URL(string: "http://localhost:8080")!))
        }
    }
}
