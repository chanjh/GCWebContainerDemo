//
//  BookmarksManager.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/18.
//

import Foundation

class BookmarksManager {
    static let shared = BookmarksManager()
    
    var bookmarks: [Bookmark] = []
    
    func save(url: String, title: String?) {
        let mark = Bookmark(url: url, title: title)
        bookmarks.append(mark)
    }
}

struct Bookmark {
    let url: String
    let title: String?
}
