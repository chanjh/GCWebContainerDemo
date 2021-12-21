//
//  Dictionary+String.swift
//  ReadFlow
//
//  Created by Gill on 2020/1/27.
//  Copyright © 2020 陈嘉豪. All rights reserved.
//

import Foundation

// MARK: -
extension Dictionary: PrivateFoundationExtensionCompatible {}

// MARK: -
public extension PrivateFoundationExtension {
    func toString() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: base, options: [])
            return String(data: jsonData, encoding: .utf8)
        } catch {
            assertionFailure()
        }
        return nil
    }
}
