//
//  PDManager.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/19.
//

import Foundation
import Zip

class PDManager {
    private var pandoraList: [Pandora] = [];
    
    var pandoras: [Pandora] {
        return pandoraList
    }
    
    func loadAll() {
        let files = PDFileManager.getAllUnZipApps()
        files.forEach { filePath in
            if let url = URL(string: filePath),
               let pandora = PDLoader(url, id: url.lastPathComponent).loadSync() {
                pandoraList.append(pandora)
            }
        }
    }
    
    func setupAll() {
        _loadInnerExtension()
    }
    
    private func _loadInnerExtension() {
        if let bundlePath = Bundle.main.path(forResource: "Extensions", ofType: "bundle"),
           let bundle = Bundle(path: bundlePath),
           let files = files(in: bundle.bundleURL) {
            files.forEach { fileName in
                PDFileManager.setupPandora(zipPath: bundle.url(forResource: fileName, withExtension: nil))
            }
        }
    }
    
    private func files(in directory: URL) -> [String]? {
        return try? FileManager.default.contentsOfDirectory(atPath: directory.relativePath)
    }
    
    private func unzip(zip: URL) -> URL? {
        return try? Zip.quickUnzipFile(zip)
    }
}
