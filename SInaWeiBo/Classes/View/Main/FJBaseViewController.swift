//
//  FJBaseViewController.swift
//  SInaWeiBo
//
//  Created by Mac on 18/10/23.
//  Copyright © 2018年 haofujie. All rights reserved.
//

import UIKit

class FJBaseViewController: UIViewController {
    
    //判断用户是否登录的标志
    var isLogin: Bool = FJUserAccountViewModel.sharedTools.isLogin
    //游客视图
    var visitorView: FJVisitorView?
    
    //帮控制器创建view
    override func loadView() {
        
        if isLogin {
            view = tableView
        } else {
            //代表没有登录
            setVisitView()
        }
        
    }
    
    private func setVisitView () {
        //创建访客视图
        visitorView = FJVisitorView()
        
        visitorView?.closure = { [weak self] in
            
            self?.loginBtn()
        }
        
        view = visitorView
        
        setupNav()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    private lazy var iconImageView: UIImageView = UIImageView()
    
    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(setImageName: nil, title: "注册", target: self, action: #selector(loginBtn))
        navigationItem.rightBarButtonItem = UIBarButtonItem(setImageName: nil, title: "登录", target: self, action: #selector(loginBtn))
    }
    
    @objc private func loginBtn () {
        
        let oauth = FJOAuthViewController()
        
        let oauthNavC = FJNavViewController(rootViewController: oauth)
        
        present(oauthNavC, animated: true) { 
            
        }
    }
    
    lazy var tableView: UITableView = UITableView()

}
