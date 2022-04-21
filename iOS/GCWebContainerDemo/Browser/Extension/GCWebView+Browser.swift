//
//  GCWebView+Browser.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/18.
//

import Foundation
@_exported import GCWebContainer
extension GCWebView {
    var browserView: BrowserView? {
        get {
            return Holder._broweserViewProperty
        }
        set(newValue) {
            Holder._broweserViewProperty = newValue
        }
    }
    
    private struct Holder {
        static var _broweserViewProperty: BrowserView?
    }
}
//
//protocol BrowserTabManagerInterface {
//    
//}
//
//extension BrowserModelConfig: BrowserTabManagerInterface {
//    
//}
