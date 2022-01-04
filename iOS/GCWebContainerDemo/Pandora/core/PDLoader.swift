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
    let id: String
    private let filesInPath: [String]
    
    init(_ path: URL, id: String) {
        self.path = path
        self.id = id
        self.filesInPath = (try? FileManager.default.contentsOfDirectory(atPath: path.relativePath)) ?? []
    }
    
    func loadSync() -> Pandora? { Pandora(path, id: id) }
    
    var popupHTML: String? {
        let pd = loadSync()
        if let popup = pd?.manifest.action?["default_popup"] as? String {
            return fileContent(at: popup)
        }
        return nil;
    }
    
    var popupFilePath: String? {
        let pd = loadSync()
        if let popup = pd?.manifest.action?["default_popup"] as? String {
            return filesInPath.first { $0 == popup }
        }
        return nil
    }
    
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
