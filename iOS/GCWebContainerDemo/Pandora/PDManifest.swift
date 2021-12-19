//
//  PDManifest.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/19.
//

import Foundation

struct PDManifest {
    static let supportedVersion = 3
    let name: String
    let version: String
    let manifestVersion: Int
    let background: PDBackgroundInfo?
    let action: Dictionary<String, Any>?
    let contentScripts: Array<PDContentScriptInfo>?
    private let raw: Dictionary<String, Any>?
    
    init?(_ fileContent: String) {
        if let data = fileContent.data(using: .utf8),
           let manifestContent = try? JSONSerialization.jsonObject(with: data,
                                                                   options : .allowFragments) as? Dictionary<String,Any>,
           let name = manifestContent["name"] as? String,
           let version = manifestContent["version"] as? String,
           let manifestVersion = manifestContent["manifest_version"] as? Int,
           manifestVersion == Self.supportedVersion {
            self.raw = manifestContent
            self.name = name
            self.version = version
            self.manifestVersion = manifestVersion
            self.background = PDBackgroundInfo(manifestContent["background"] as? Dictionary<String, Any>)
            self.action = manifestContent["action"] as? Dictionary<String, Any>
            let contents = manifestContent["content_scripts"] as? [Dictionary<String, Any>]
            self.contentScripts = contents?.compactMap({ PDContentScriptInfo($0) })
            return
        }
        return nil
    }
    
    private static func fileContent(at path: String) -> Dictionary<String,Any>? {
        if let data = FileManager.default.contents(atPath: path),
           let json = try? JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any> {
            return json
        }
        return nil
    }
}

//"content_scripts": [
//    {
//        "matches": ["https://*.nytimes.com/*"],
//        "exclude_matches": ["*://*/*business*"],
//        "include_globs": ["*nytimes.com/???s/*"],
//        "exclude_globs": ["*science*"],
//        "css": ["my-styles.css"],
//        "js": ["content-script.js"],
//        "all_frames": true,
//    }
//],
// todo: 可选值等
struct PDContentScriptInfo {
    let matches: Array<String>
    let excludeMatches: Array<String>
    let includeGlobs: Array<String>
    let excludeGlobs: Array<String>
    let run_at: PDRunAtType
    let css: Array<String>
    let js: Array<String>
    let allFrame: Bool
    
    init?(_ content: Dictionary<String, Any>?) {
        self.matches = []
        self.excludeMatches = []
        self.includeGlobs = []
        self.excludeGlobs = []
        self.run_at = .idle
        self.css = []
        self.js = []
        self.allFrame = true
    }
}

//"background": {
//  "service_worker": "background.js",
//  "type": "module"
//}
struct PDBackgroundInfo {
    let worker: String
    let type: String?
    init?(_ background: Dictionary<String, Any>?) {
        if let worker = background?["service_worker"] as? String {
            self.worker = worker
            self.type = background?["type"] as? String
            return
        }
        return nil
    }
}

enum PDRunAtType: String {
    case idle = "document_idle"
    case start = "document_start"
    case end = "document_end"
}
