//
//  HMDiscoverViewController.swift
//  VVeibo21
//
//  Created by Apple on 18/10/22.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class FJDiscoverViewController: FJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //父类的一个属性，继承
        if !self.isLogin {
            
            self.visitorView?.setupVisitorViewInfo(imageName: "visitordiscover_image_message", title: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
            
            return
        }
        
        //        setupUI()
    }

}
