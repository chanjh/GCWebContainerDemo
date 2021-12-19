//
//  GCBrowserViewController.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/18.
//

import UIKit

class GCBrowserViewController: UIViewController {
    let webView: GCWebView
    let url: URL?
    
    lazy private var progressView: UIProgressView = {
        self.progressView = UIProgressView.init(frame: CGRect(x: 0, y: 0,
                                                              width: view.frame.width, height: 2))
        self.progressView.tintColor = .blue
        self.progressView.trackTintColor = .white
        return self.progressView
    }()
    init(webView: GCWebView? = nil, url: URL? = nil) {
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
        if webView.url == nil, let url = url {
            webView.load(URLRequest(url: url))
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Menu",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didClickMenu(sender:)))

        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil);
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
}

extension GCBrowserViewController: BrowserMenuControllerDelegate {
    func closeBrowser() {
        navigationController?.popViewController(animated: true)
    }
}
