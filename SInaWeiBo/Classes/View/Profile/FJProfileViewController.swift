//
//  FJProfileViewController.swift
//  VVeibo21
//
//  Created by Apple on 18/10/22.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class FJProfileViewController: FJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //我父类的一个属性，继承
        if !self.isLogin {
            
            self.visitorView?.setupVisitorViewInfo(imageName: "visitordiscover_image_profile", title: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
            
            return
        }
        
        //        setupUI()
    }

}
