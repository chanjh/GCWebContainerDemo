//
//  GCBrowserViewController.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/18.
//

import UIKit
import WebKit
import SnapKit

class GCBrowserViewController: UIViewController {
    let webView: PDWebView
    let url: URL?
//    var runner: PDRunner?
    
    lazy private var progressView: UIProgressView = {
        self.progressView = UIProgressView.init(frame: CGRect(x: 0, y: 0,
                                                              width: view.frame.width, height: 2))
        self.progressView.tintColor = .blue
        self.progressView.trackTintColor = .white
        return self.progressView
    }()
    
    init(webView: PDWebView? = nil, url: URL? = nil) {
        self.url = url
        if let wv = webView {
            self.webView = wv
        } else {
            self.webView = BrowserManager.shared.makeBrowser()
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.frame = CGRect(origin: CGPoint.zero, size: view.frame.size)
        view.addSubview(webView)
        view.addSubview(progressView)
        if let url = webView.url {
            _ = webView.load(URLRequest(url: url))
        }
        _addRightButton()
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    private func _addRightButton() {
        let menu = UIBarButtonItem(title: "Menu",
                                   style: .plain,
                                   target: self,
                                   action: #selector(didClickMenu(sender:)))
        var items = [menu]
        PDManager.shared.pandoras.enumerated().forEach {
            if $1.popupFilePath == nil {
                return
            }
            let item = UIBarButtonItem(title: $1.manifest.name,
                                       style: .plain,
                                       target: self,
                                       action: #selector(didClickExtension(sender:)))
            item.tag = $0
            items.append(item)
        }
        navigationItem.setRightBarButtonItems(items, animated: true)
    }

    // Observe value
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?, change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                self.progressView.progress = Float(self.webView.estimatedProgress);
            })
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { (finish) in
                    self.progressView.setProgress(0.0, animated: false)
                })
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

extension GCBrowserViewController {
    @objc func didClickMenu(sender: UIBarButtonItem) {
        let menu = BrowserMenuController(browserId: webView.identifier!)
        menu.delegate = self
        menu.modalPresentationStyle = .popover
        let pop = menu.popoverPresentationController
        pop?.permittedArrowDirections = .up
        // todo
        pop?.sourceView = navigationController?.navigationBar
        present(menu, animated: true, completion: nil)
    }
    
    @objc func didClickExtension(sender: UIBarButtonItem) {
        let index = sender.tag
        let pandora = PDManager.shared.pandoras[index]
        let runner = PDRunner(pandora: pandora)
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
}

extension GCBrowserViewController: BrowserMenuControllerDelegate {
    func closeBrowser() {
        navigationController?.popViewController(animated: true)
    }
    
    func openPopup() {
//        if let presentedVC = self.presentedViewController {
//            presentedVC.dismiss(animated: false, completion: nil)
//        }
//        if let popupPage = runner?.runPageAction(),
//            let url = runner?.pandora.popupFilePath {
//            let vc = UIViewController()
//            vc.view.addSubview(popupPage)
//            popupPage.snp.makeConstraints { make in
//                make.edges.equalToSuperview()
//            }
//            vc.modalPresentationStyle = .popover
//            let pop = vc.popoverPresentationController
//            pop?.permittedArrowDirections = .up
//            // todo
//            pop?.sourceView = navigationController?.navigationBar
//            popupPage.loadFileURL(url, allowingReadAccessTo: url)
//            present(vc, animated: true, completion: nil)
//        }
    }
}
