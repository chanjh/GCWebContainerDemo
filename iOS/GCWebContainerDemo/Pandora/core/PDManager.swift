//
//  PDManager.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/19.
//

import Foundation
import Zip

class PDManager {
    static let shared = PDManager();
    private var pandoraList: [Pandora] = [];
    
    var pandoras: [Pandora] {
        return loaders.compactMap { return $0.pandora }
    }
    
    private(set) var loaders: [PDLoader] = [];
    private(set) var runners: [PDRunner] = [];
    
    func loadPandora(path: URL, id: String) -> Pandora? {
        let loader = PDLoader(path, id: id)
        loaders.append(loader)
        if let pandora = loader.loadSync() {
//            pandoraList.append(contentsOf: pandoras)
            return pandora
        }
        return nil
    }
    
    // 把所有已经解压的扩展，加载到内容里
    func loadAll() {
        let files = PDFileManager.getAllUnZipApps()
        files.forEach { filePath in
            if let url = URL(string: filePath),
                !loaders.contains(where: { $0.loadSync()?.id == url.lastPathComponent }) {
                let loader = PDLoader(url, id: url.lastPathComponent)
                loaders.append(loader)
                if let pandora = loader.loadSync() {
                    let runner = makeRunner(pandora)
//                    runners.append(runner)
                    runner.run()
                }
            }
        }
    }
    
    func tryToSetupAll() {
        // 从 IPA 中解压
        _loadInnerExtension()
        // todo: 上次解压失败的，重新开始解压
    }
    
    func makeRunner(_ pandora: Pandora) -> PDRunner {
//        if let runner = runners.first(where: { $0.pandora.id == pandora.id }) {
//            return runner
//        }
        let runner = PDRunner(pandora: pandora)
        runners.append(runner)
        return runner
    }
    
    func removeRunner(_ runner: PDRunner) {
        runners.removeAll {
            $0 == runner
        }
    }
    
    private func _loadInnerExtension() {
        let key = "k_Pandora_DidSetupAllBundleApp_key"
        if UserDefaults.standard.bool(forKey: key) {
            return
        }
        if let bundlePath = Bundle.main.path(forResource: "Extensions", ofType: "bundle"),
           let bundle = Bundle(path: bundlePath),
           let files = files(in: bundle.bundleURL) {
            files.forEach { fileName in
                PDFileManager.setupPandora(zipPath: bundle.url(forResource: fileName, withExtension: nil))
            }
        }
        UserDefaults.standard.set(true, forKey: key)
    }
    
    private func files(in directory: URL) -> [String]? {
        return try? FileManager.default.contentsOfDirectory(atPath: directory.relativePath)
    }
    
    private func unzip(zip: URL) -> URL? {
        return try? Zip.quickUnzipFile(zip)
    }
}

extension PDManager {
    var contentScripts: [String]? {
        var scripts: [String] = []
        loaders.forEach { loader in
            scripts.append(contentsOf: loader.contentScripts ?? [])
        }
        return scripts
    }
}
