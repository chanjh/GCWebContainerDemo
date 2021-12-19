//
//  PDLoader.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/19.
//

import Foundation
import Zip

class PDLoader {
    let path: URL
    private let filesInPath: [String]
    
    init(_ path: URL) {
        self.path = path
        self.filesInPath = (try? FileManager.default.contentsOfDirectory(atPath: path.relativePath)) ?? []
    }
    
    func loadSync() -> Pandora? { Pandora(path) }
    
    var backgroundScript: String? {
        return fileContent(at: PDFileNameType.background.rawValue)
    }
    
    var manifest: String? {
        return fileContent(at: PDFileNameType.manifest.rawValue)
    }
    
    func fileContent(at fileName: String) -> String? {
        if filesInPath.contains(where: { $0 == fileName }),
           let data = FileManager.default.contents(atPath: path.relativePath + "/" + fileName){
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

enum PDFileNameType: String {
    case background = "background.js"
    case manifest = "manifest.json"
}
