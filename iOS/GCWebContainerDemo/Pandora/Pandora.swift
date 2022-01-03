//
//  Pandora.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/19.
//

import Foundation

struct Pandora {
    let pdName: String;
    let pdPath: URL;
    let manifest: PDManifest;
    private var pdId: String?
    var id: String? {
        return pdId;
    }
    
    var background: String? {
        if let worker = manifest.background?.worker,
           let data = FileManager.default.contents(atPath: pdPath.appendingPathComponent(worker).relativePath) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    mutating func run() {
        self.pdId = UUID().uuidString
    }
    
    init?(_ path: URL) {
        var tPath = path
        tPath.appendPathComponent("manifest.json")
        if let data = FileManager.default.contents(atPath: tPath.relativePath),
           let manifestContent = String(data: data, encoding: .utf8),
           let manifest = PDManifest(manifestContent) {
            self.pdName = path.lastPathComponent
            self.pdPath = path
            self.manifest = manifest
            return
        }
        return nil
    }
}
