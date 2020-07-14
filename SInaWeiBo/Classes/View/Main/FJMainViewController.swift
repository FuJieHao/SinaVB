//
//  FJMainViewController.swift
//  VVeibo21
//
//  Created by Apple on 18/10/22.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class FJMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabbar = FJTabBar()
        
        tabbar.closure = {
            // 04 接收回调
            if !FJUserAccountViewModel.sharedTools.isLogin {
                
                SVProgressHUD.showError(withStatus: "请先登录, 亲~")
                return
            }
            //  代码执行到此,表示登录
            
            let composeView = FJComposeView()
            
            composeView.show(target: self)
        }
        //通过kvc给计算型属性赋值
        self.setValue(tabbar, forKey: "tabBar")
        
        // 添加子控制器
        addChildViewController(vc: FJHomeViewController(), title: "首页", imgName: "tabbar_home")
        addChildViewController(vc: FJMessageViewController(), title: "消息", imgName: "tabbar_message_center")
        addChildViewController(vc: FJDiscoverViewController(), title: "发现", imgName: "tabbar_discover")
        addChildViewController(vc: FJProfileViewController(), title: "我", imgName: "tabbar_profile")
        
        
    }
    
    
    /// 添加子控制器方法
    ///
    /// - parameter vc:      子控制器
    /// - parameter title:   名字
    /// - parameter imgName: 图片名字
    private func addChildViewController(vc: UIViewController, title: String, imgName: String){
        // 设置 title
        vc.title = title
//                vc.navigationItem.title = "首页"
//                vc.tabBarItem.title = "首页"
        // 设置文字颜色
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange], for: UIControlState.selected)
        // 设置图片
        vc.tabBarItem.image = UIImage(named: imgName)
        // 选中的图片(alwaysOriginal 原生渲染方式)
        vc.tabBarItem.selectedImage = UIImage(named: "\(imgName)_selected")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        // 添加
        let vcNav = FJNavViewController(rootViewController: vc)
        addChildViewController(vcNav)
    }

}
