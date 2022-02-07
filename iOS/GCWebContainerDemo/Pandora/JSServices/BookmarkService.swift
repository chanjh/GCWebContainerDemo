//
//  BookmarkService.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/2/4.
//

import Foundation

class BookmarkService: BaseJSService, JSServiceHandler {
    var handleServices: [JSServiceType] {
        return [.bookmarksCreate,
                .bookmarksGetTree,
                .bookmarksRemove,
                .bookmarksUpdate]
    }

    func handle(params: Any?, serviceName: String, callback: String?) {
        guard let params = params as? [String: Any] else {
            return
        }
        if serviceName == JSServiceType.bookmarksCreate.rawValue {
            
        }
    }
}

extension JSServiceType {
    static let bookmarksCreate = JSServiceType("bookmarks.create")
    static let bookmarksGetTree = JSServiceType("bookmarks.getTree")
    static let bookmarksRemove = JSServiceType("bookmarks.remove")
    static let bookmarksUpdate = JSServiceType("bookmarks.update")
}
