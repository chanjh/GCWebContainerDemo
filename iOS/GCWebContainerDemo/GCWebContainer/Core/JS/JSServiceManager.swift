//
//  RFJSServiceManager.swift
//  ReadFlow
//
//  Created by Gill on 2020/1/27.
//  Copyright © 2020 陈嘉豪. All rights reserved.
//

import WebKit

// JS --> Native
class JSServiceManager: NSObject {
    weak var webView: WKWebView?
    static let scriptMessageName = "invoke"
    static let kCallback = "callback";
    private let handerQueue = DispatchQueue(label: "com.chanjh.readflow.jshandler.\(UUID().uuidString)")
    @ThreadSafe private(set) var handlers = [JSServiceHandler]()
    
    init(_ webView: WKWebView) {
        self.webView = webView
        super.init()
        webView.configuration.userContentController.add(self, name: Self.scriptMessageName)
    }

    func register(handler: JSServiceHandler) {
        handlers.append(handler)
    }

    func handle(message: String, _ params: [String: Any], callback: String?) {
        print("收到前端调用: \(message)")
        handerQueue.async {
            let cmd = JSServiceType(rawValue: message)
            self.handlers.forEach { (handler) in
                if handler.handleServices.contains(cmd) {
                    DispatchQueue.main.async {
                        handler.handle(params: params, serviceName: message, callback: callback)
                    }
                }
            }
        }
    }
}

extension JSServiceManager: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        guard message.name == Self.scriptMessageName,
                let body = message.body as? [String: Any],
            let method = body["action"] as? String,
            let agrs = body["params"] as? [String: Any] else {
                // todo: error
                return
        }
        handle(message: method, agrs, callback: body[Self.kCallback] as? String)
    }
}
