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
        if let bundlePath = Bundle.main.path(forResource: "Extensions", ofType: "bundle"),
           let bundle = Bundle(path: bundlePath),
           let files = files(in: bundle.bundleURL) {
            files.forEach { fileName in
                if fileName.hasSuffix(".zip"),
                   let filePath = bundle.url(forResource: fileName, withExtension: nil),
                   let unzipDirectory = try? Zip.quickUnzipFile(filePath),
                   let pandora = PDLoader(unzipDirectory).loadSync() {
                    pandoraList.append(pandora)
                }
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
