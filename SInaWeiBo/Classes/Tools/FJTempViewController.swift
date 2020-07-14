//
//  FJTempViewController.swift
//  SInaWeiBo
//
//  Created by Mac on 18/10/22.
//  Copyright © 2018年 haofujie. All rights reserved.
//

import UIKit

class FJTempViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.cyan
        
        setupNav()
    }
    
    @objc private func pushClick() {
        
        let vc = FJTempViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    @objc private func back() {
//        print("返回首页")
//        _ = navigationController?.popViewController(animated: true)
//    }

    private func setupNav() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(setImageName: nil, title: "PUSH", target: self, action:#selector(pushClick))
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(setImageName: nil, title: "🔙", target: self, action: #selector(back))
        
        
        navigationItem.title = "是第\(navigationController?.childViewControllers.count ?? 0)个控制器"
    }
}
