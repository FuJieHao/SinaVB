//
//  FJNavViewController.swift
//  SInaWeiBo
//
//  Created by Mac on 18/10/22.
//  Copyright © 2018年 haofujie. All rights reserved.
//

import UIKit

class FJNavViewController: UINavigationController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        //当程序员自定义导航的返回按钮后，屏幕左侧的右滑手势失效了
        interactivePopGestureRecognizer?.delegate = self
        
    }
    
    /*
        -当我们第一次push新控制器上title显示为首页的title，以后显示的都是返回
     */
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        var title: String
        
        if childViewControllers.count > 0 {
            
            title = "🔙"
            
            if childViewControllers.count == 1 {
                title = childViewControllers.first?.title ?? ""
            }
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(setImageName: nil, title: title, target: self, action: #selector(back))
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
    @objc private func back() {
        
        popViewController(animated: true)
    }
    
    //如果是首页的话，然后又右滑，不能完成，如果不实现，返回均为true
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        return childViewControllers.count != 1
    }

}
