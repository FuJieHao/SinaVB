//
//  FJMessageViewController.swift
//  VVeibo21
//
//  Created by Apple on 18/10/22.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class FJMessageViewController: FJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //我父类的一个属性，继承
        if !self.isLogin {
            
            self.visitorView?.setupVisitorViewInfo(imageName: "visitordiscover_image_message", title: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
            
            return
        }
        
//        setupUI()
    }

}
