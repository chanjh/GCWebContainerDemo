//
//  BrowserView.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/16.
//

import SnapKit
protocol BrowserViewDelegate: NSObject {
    func didClickTabs();
    func didClickMenu();
    func didClickExtension(sender: UIBarButtonItem);
}

class BrowserView: UIView {
    weak var webView: GCWebView?
    var delegate: BrowserViewDelegate?
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
        return textField
    }()
    init(_ webView: GCWebView) {
        self.webView = webView
        super.init(frame: .zero)
        webView.actionHandler.addObserver(self)
        addSubview(webView)
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
        webView?.snp.makeConstraints { make in
            make.top.equalTo(addressView.snp.bottom)
            make.bottom.equalTo(toolBar.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func load(url: URL) {
        _ = webView?.load(URLRequest(url: url))
    }
}

extension BrowserView: GCWebViewActionObserver {
    
}
extension BrowserView {
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
