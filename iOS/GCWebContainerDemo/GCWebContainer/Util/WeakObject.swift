//
//  WeakObject.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/27.
//

import Foundation

class Weak<T: AnyObject> {
  weak var value : T?
  init (value: T) {
    self.value = value
  }
}
