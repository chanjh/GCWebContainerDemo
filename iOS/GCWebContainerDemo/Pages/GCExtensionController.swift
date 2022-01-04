//
//  GCExtensionController.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/4.
//

import UIKit
import Tiercel

class GCExtensionController: UIViewController {
    lazy var sessionManager: SessionManager = {
        var configuration = SessionConfiguration()
        configuration.allowsCellularAccess = true
        let manager = SessionManager("default", configuration: configuration)
        return manager
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Extension"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download Extension",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(downloadAction))
        view.addSubview(tableView)
    }
}

extension GCExtensionController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension GCExtensionController {
    @objc func downloadAction() {
        let task = sessionManager.download("http://ksria.com/simpread/crx/2.2.0/simpread.zip")
        task?.progress(onMainQueue: true) { (task) in
            let progress = task.progress.fractionCompleted
            print("下载中, 进度：\(progress)")
        }.success { (task) in
            PDFileManager.setupPandora(zipPath: URL(string:  task.filePath))
            print("下载完成")
        }.failure { (task) in
            print("下载失败")
        }
    }
}
