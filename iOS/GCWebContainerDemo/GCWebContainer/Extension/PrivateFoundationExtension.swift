//
//  PrivateFoundationExtension.swift
//  ReadFlow
//
//  Created by Gill on 2020/1/27.
//  Copyright © 2020 陈嘉豪. All rights reserved.
//

import Foundation

public class PrivateFoundationExtension<BaseType> {
    var base: BaseType
    init(_ base: BaseType) {
        self.base = base
    }
}

public protocol PrivateFoundationExtensionCompatible {
    associatedtype PrivateFoundationCompatibleType
    var ext: PrivateFoundationCompatibleType { get }
    static var ext: PrivateFoundationCompatibleType.Type { get }
}

public extension PrivateFoundationExtensionCompatible {
    var ext: PrivateFoundationExtension<Self> {
        return PrivateFoundationExtension(self)
    }
    static var ext: PrivateFoundationExtension<Self>.Type {
        return PrivateFoundationExtension.self
    }
}
