//
//  RuntimeService.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/2.
//

import Foundation

class RuntimeService: BaseJSService, JSServiceHandler {
    var handleServices: [JSServiceType] {
        return [.onPandoraInstalled]
    }
    func handle(params: [String : Any], serviceName: String, callback: String?) {
    }
}

extension JSServiceType {
    static let onPandoraInstalled   = JSServiceType("runtime.onInstalled")
}
