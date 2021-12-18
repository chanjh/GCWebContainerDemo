//
//  JSServiceUtil.swift
//  ReadFlow
//
//  Created by Gill on 2020/1/27.
//  Copyright © 2020 陈嘉豪. All rights reserved.
//

import Foundation

class JSServiceUtil {
    static func fixUnicodeCtrlCharacters(_ string: String) -> String {
        var res = string.replacingOccurrences(of: "\u{2029}", with: "\\u{2029}")
        res = res.replacingOccurrences(of: "\\\\u{2029}", with: "\\u{2029}")
        res = res.replacingOccurrences(of: "\u{2028}", with: "\\u{2028}")
        res = res.replacingOccurrences(of: "\\\\u{2028}", with: "\\u{2028}")
        return res
    }
}
