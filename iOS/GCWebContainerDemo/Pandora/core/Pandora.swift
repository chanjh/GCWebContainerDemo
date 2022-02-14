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
        return pdId
    }
    
    var background: String? {
        if let worker = manifest.background?.worker,
           let data = FileManager.default.contents(atPath: pdPath.appendingPathComponent(worker).relativePath) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    var backgrounds: [String]? {
        if let worker = manifest.background?.worker,
           let data = FileManager.default.contents(atPath: pdPath.appendingPathComponent(worker).relativePath),
           let script = String(data: data, encoding: .utf8) {
            return [script]
        } else if let works = manifest.backgroundV2?.worker {
            return works.compactMap {
                if let data = FileManager.default.contents(atPath: pdPath.appendingPathComponent($0).relativePath) {
                    return String(data: data, encoding: .utf8)
                }
                return nil
            }
        }
        return nil
    }
    
    var popupFilePath: URL? {
        if let popup = manifest.action?["default_popup"] as? String,
           let filesInPath = (try? FileManager.default.contentsOfDirectory(atPath: pdPath.relativePath)),
           filesInPath.contains(where: { $0 == popup }) {
            return URL(string: "file://" + pdPath.relativePath + "/" + popup)
        }
        return nil
    }
    
    var optionPageFilePath: URL? {
        if let page = manifest.option?.page,
           let filesInPath = (try? FileManager.default.contentsOfDirectory(atPath: pdPath.relativePath)),
           // todo: 支持 page 为 ./options/options.html 这种格式
           filesInPath.contains(where: { $0 == page }) {
            return URL(string: "file://" + pdPath.relativePath + "/" + page)
        }
        return nil
    }

    init?(_ path: URL, id: String) {
        var tPath = path
        tPath.appendPathComponent("manifest.json")
        if let data = FileManager.default.contents(atPath: tPath.relativePath),
           let manifestContent = String(data: data, encoding: .utf8),
           let manifest = PDManifest(manifestContent) {
            self.pdName = path.lastPathComponent
            self.pdPath = path
            self.manifest = manifest
            self.pdId = id
            return
        }
        return nil
    }
}
