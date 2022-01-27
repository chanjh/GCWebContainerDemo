//
//  TabsManagerViewController.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/17.
//

import SnapKit

protocol TabsManagerViewControllerDelegate: NSObjectProtocol {
    func didSelectWebView(_ webView: GCWebView)
    func didAddUrl(_ url: URL?)
}

class TabsManagerViewController: UIViewController {
    var delegate: TabsManagerViewControllerDelegate?
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Multi Tab"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Browser",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didClickAddBrowser))
        view.addSubview(tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
}

extension TabsManagerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TabsManager.shared.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = TabsManager.shared.title(at: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if let webView = TabsManager.shared.browser(at: indexPath.row) {
            delegate?.didSelectWebView(webView)
            dismiss(animated: true, completion: nil)
        }
    }
}

extension TabsManagerViewController {
    @objc
    func didClickAddBrowser() {
        let alert = UIAlertController(title: "URL", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = "https://baidu.com"
        }
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { [weak self] _ in
            if let url = URL(string: alert.textFields?.first?.text ?? "") {
                self?.delegate?.didAddUrl(url)
                self?.dismiss(animated: true, completion: nil)
            }
        }))
        alert.addAction((UIAlertAction(title: "cancel", style: .cancel, handler: nil)))
        present(alert, animated: true, completion: nil)
    }
}
