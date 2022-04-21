//
//  PDBaseJSService.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/4/21.
//

import Foundation

class PDBaseJSService: BaseJSService {
    override
    func findSenderId(on message: JSServiceMessageInfo) -> String? {
        if let pdWebView = (self.webView as? PDWebView) {
            switch pdWebView.type {
            case .popup(let id):
                return id
            case .background(let id):
                return id
            case .browserAction(let id):
                return id
            case .content:
                return message.contentWorld.name ?? "\(webView?.identifier ?? 0)"
            }
        } else {
            return super.findSenderId(on: message)
        }
    }
}