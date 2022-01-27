//
//  BrowserView.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/16.
//

import SnapKit

protocol BrowserViewToolBarDelegate: NSObject {
    func didClickTabs();
    func didClickMenu();
    func didClickExtension(sender: UIBarButtonItem);
}

protocol BrowserViewDelegate: BrowserViewToolBarDelegate {}

class BrowserView: UIView {
    var gcWebView: GCWebView?
    weak var delegate: BrowserViewDelegate?
    lazy var toolBar: UIToolbar = {
        let tool = UIToolbar()
        var items = [UIBarButtonItem(title: "Tabs", style: .plain, target: self, action: #selector(didClickTabs)),
                     UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(didClickMenu)),]
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
        tool.setItems(items, animated: true)
        return tool
    }()
    lazy var addressView: UITextField = {
        let textField = UITextField()
        textField.placeholder = "URL"
        textField.borderStyle = .line
        textField.delegate = self
        return textField
    }()
    init(_ webView: GCWebView? = nil) {
        self.gcWebView = webView
        super.init(frame: .zero)
        webView?.browserView = self
        webView?.actionHandler.addObserver(self)
        if let wv = webView {
            addSubview(wv)
        }
        addSubview(addressView)
        addSubview(toolBar)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addressView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        toolBar.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        gcWebView?.snp.makeConstraints { make in
            make.top.equalTo(addressView.snp.bottom)
            make.bottom.equalTo(toolBar.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func load(url: URL) {
        if url != gcWebView?.url {
            _ = gcWebView?.load(URLRequest(url: url))
        }
        addressView.text = url.relativeString
    }
    
    func reload(webView: GCWebView) {
        gcWebView?.removeFromSuperview()
        self.gcWebView = webView
        webView.browserView = self
        webView.actionHandler.addObserver(self)
        addSubview(webView)
        bringSubviewToFront(toolBar)
        bringSubviewToFront(addressView)
        
        gcWebView?.snp.makeConstraints { make in
            make.top.equalTo(addressView.snp.bottom)
            make.bottom.equalTo(toolBar.snp.bottom)
            make.left.right.equalToSuperview()
        }
        addressView.text = gcWebView?.url?.relativeString
    }
}

extension BrowserView: GCWebViewActionObserver {
    
}

extension BrowserView: WebContainerUIConfig,
                       BrowserModelConfig,
                       BrowerTabManagerInterface {
    var webView: GCWebView {
        return self.gcWebView!
    }
    
    var tabManager: BrowerTabManagerInterface {
        return self
    }
    
    func addTab(_ url: URL?) {
        let webView = TabsManager.shared.makeBrowser(model: self, ui: self)
        reload(webView: webView)
        if let url = url {
            load(url: url)
        }
    }
    
    func removeTabs(_ tabs: [String]) {
        tabs.forEach { id in
            TabsManager.shared.remove(id)
        }
        if tabs.contains(where: { (webView as? PDWebView)?.identifier == $0 })  {
            if let web = TabsManager.shared.browser(at: 0) {
                reload(webView: web)
            }
        }
    }
}
extension BrowserView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let url = URL(string: textField.text ?? "") {
            load(url: url)
        }
    }
    
    @objc func didClickTabs() {
        delegate?.didClickTabs()
    }
    @objc func didClickMenu() {
        delegate?.didClickMenu()
    }
    
    @objc func didClickExtension(sender: UIBarButtonItem) {
        delegate?.didClickExtension(sender: sender)
    }
}
