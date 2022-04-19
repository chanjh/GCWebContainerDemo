//
//  PandoraDelegateImpl.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/4/18.
//

import UIKit

class PandoraDelegateImpl: PandoraDelegate {
    weak var browser: BrowserViewController?
    init(_ browser: BrowserViewController) {
        self.browser = browser
    }
    
    func openURL(_ options: OpenURLOptions) -> GCTabInfo {
        let tab = browser?.didAddUrl(options.url)
        return GCTabInfo(id: "\(tab?.id ?? 0)")
    }
    
    func removeTab(_ options: GCTabInfo) {
//        TabsManager.shared.remove(options.id)
    }
}
