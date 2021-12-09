//
//  String+base64.swift
//  WebViewDemo
//
//  Created by Gill on 2019/11/19.
//  Copyright © 2019 Gill. All rights reserved.
//

import Foundation

extension String {
    public func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    public func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
