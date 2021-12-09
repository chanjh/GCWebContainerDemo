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
        //服务端返回了特殊的unicode控制字符，如\u{e2}（很奇怪，p出来是\u{e2},但实际是\u{2029}）,需要过滤掉，否则传入js执行会出错。
        var res = string.replacingOccurrences(of: "\u{2029}", with: "\\u{2029}")
        res = res.replacingOccurrences(of: "\\\\u{2029}", with: "\\u{2029}")
        res = res.replacingOccurrences(of: "\u{2028}", with: "\\u{2028}")
        res = res.replacingOccurrences(of: "\\\\u{2028}", with: "\\u{2028}")
        return res
    }
}
