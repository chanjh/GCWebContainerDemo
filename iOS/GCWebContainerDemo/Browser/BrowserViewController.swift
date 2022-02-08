//
//  BrowserViewController.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/16.
//

import UIKit
import SnapKit

class BrowserViewController: UIViewController {
    private var browserView: BrowserView
    private var url: URL?
    
    init(url: URL? = nil) {
        self.url = url
        self.browserView = BrowserView()
        let webView = TabsManager.shared.makeBrowser(model: browserView, ui: browserView)
        browserView.reload(webView: webView)
        if let url = url {        
            browserView.load(url: url)
        }
        super.init(nibName: nil, bundle: nil)
        browserView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(browserView)
        browserView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if let url = url {
            browserView.load(url: url)
        }
        TabsManager.shared.addObserver(self)
    }
}

extension BrowserViewController: BrowserViewDelegate, BrowserMenuControllerDelegate, TabsManagerViewControllerDelegate {
    // --- BrowserViewDelegate
    func didClickTabs() {
        let controller = TabsManagerViewController()
        let nav = UINavigationController(rootViewController: controller)
        controller.delegate = self
        present(nav, animated: true, completion: nil)
    }
    
    func didClickMenu() {
        let menu = BrowserMenuController(browserId: (browserView.webView as? PDWebView)!.identifier!)
//        menu.delegate = self
        menu.modalPresentationStyle = .popover
        let pop = menu.popoverPresentationController
        pop?.permittedArrowDirections = .up
        // todo
        pop?.sourceView = navigationController?.navigationBar
        present(menu, animated: true, completion: nil)
    }
    
    func didClickExtension(sender: UIBarButtonItem) {
        let index = sender.tag
        let pandora = PDManager.shared.pandoras[index]
        let runner = PDManager.shared.makeRunner(pandora)
        if let presentedVC = self.presentedViewController {
            presentedVC.dismiss(animated: false, completion: nil)
        }
        let popupPage = runner.runPageAction()
        if let url = pandora.popupFilePath {
            let vc = UIViewController()
            vc.view.addSubview(popupPage)
            popupPage.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            vc.modalPresentationStyle = .popover
            let pop = vc.popoverPresentationController
            pop?.permittedArrowDirections = .up
            // todo
            pop?.sourceView = navigationController?.navigationBar
            popupPage.loadFileURL(url, allowingReadAccessTo: url)
            present(vc, animated: true, completion: nil)
        }
    }
    
    // --- BrowserMenuControllerDelegate
    func closeBrowser() {
        
    }
    // --- TabsManagerViewControllerDelegate
    func didSelectWebView(_ webView: GCWebView) {
        browserView.reload(webView: webView)
    }
    
    func didAddUrl(_ url: URL?) {
        let webView = TabsManager.shared.makeBrowser(model: browserView, ui: browserView)
        browserView.reload(webView: webView)
        if let url = url {        
            browserView.load(url: url)
        }
    }
    
//    func didSelectWebView(_ webView: GCWebView, url: URL?) {
//        browserView.removeFromSuperview()
//        self.url = url ?? webView.url
//        self.browserView = BrowserView(webView)
//        browserView.delegate = self
//
//        view.addSubview(browserView)
//        browserView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        if let url = self.url {
//            browserView.load(url: url)
//        }
//    }
}

extension BrowserViewController: TabsManagerListerner {
    func onActivated(tabId: Int) {

    }

    func onUpdated(tabId: Int, changeInfo: TabChangeInfo) {

    }
    
    func onRemoved(tabId: Int, removeInfo: TabRemoveInfo) {
        if tabId == browserView.gcWebView?.identifier {
           if let web = TabsManager.shared.browser(at: 0) {
               browserView.reload(webView: web)
           } else {
               let web = TabsManager.shared.makeBrowser(model: browserView, ui: browserView)
               browserView.reload(webView: web)
           }
        }
    }
}
