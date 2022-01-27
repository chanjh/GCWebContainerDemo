//
//  GCDemoHomeController.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/18.
//

import UIKit

class GCDemoHomeController: UIViewController {
    lazy var tableView: UITableView = {
        let table = UITableView(frame: view.frame)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return table
    }()
    let cellTitle: [String] = ["Multi-Tab Manage", "Bookmarks", "Extensions", "BrowserView"]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
}

extension GCDemoHomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return cellTitle.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = cellTitle[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            let controller = GCMultiTabController()
            navigationController?.pushViewController(controller, animated: true)
        } else if (indexPath.row == 2) {
            let controller = GCExtensionController()
            navigationController?.pushViewController(controller, animated: true)
        } else if (indexPath.row == 3) {
            let controller = BrowserViewController()
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
