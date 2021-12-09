//
//  ThreadSafe.swift
//  ReadFlow
//
//  Created by Gill on 2020/1/27.
//  Copyright © 2020 陈嘉豪. All rights reserved.
//

import Foundation

/// 使用 DispatchSemaphore 保证线程安全的读写操作
@propertyWrapper
struct ThreadSafe<Value> {
    private let semaphore = DispatchSemaphore(value: 1)
    private var value: Value

    init(wrappedValue: Value) {
        value = wrappedValue
    }

    var wrappedValue: Value {
        get {
            semaphore.wait()
            defer {
                semaphore.signal()
            }
            return value
        }

        set {
            semaphore.wait()
            defer {
                semaphore.signal()
            }
            value = newValue
        }
    }
}
