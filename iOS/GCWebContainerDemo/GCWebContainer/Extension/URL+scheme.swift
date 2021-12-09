//
//  URL+scheme.swift
//  WebViewDemo
//
//  Created by Gill on 2019/11/19.
//  Copyright © 2019 Gill. All rights reserved.
//

import Foundation

extension URL {
    func change(schemeTo scheme: String) -> URL {
        guard var urlComponent = URLComponents.init(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        urlComponent.scheme = scheme
        return urlComponent.url ?? self
    }
}
