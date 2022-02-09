//
//  PDPopUpViewController.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/2/9.
//

import SnapKit

class PDPopUpViewController: UIViewController {
    let pandora: Pandora
    private weak var runner: PDRunner?
    
    init(_ pandora: Pandora) {
        self.pandora = pandora
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runner = PDManager.shared.makeRunner(pandora)
        if let popupPage = runner?.runPageAction(),
           let url = pandora.popupFilePath {
            view.addSubview(popupPage)
            popupPage.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            popupPage.loadFileURL(url, allowingReadAccessTo: url)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let runner = runner {
//            runner.bgRunner?.removeFromSuperview()
            PDManager.shared.removeRunner(runner)
        }
    }
}
