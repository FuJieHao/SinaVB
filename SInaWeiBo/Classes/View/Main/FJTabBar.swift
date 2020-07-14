//
//  FJTabBar.swift
//  SInaWeiBo
//
//  Created by Mac on 18/10/22.
//  Copyright © 2018年 haofujie. All rights reserved.
//

import UIKit

//代理
//protocol FJTabBarDelegate:NSObjectProtocol {
//    func tabBarWithComposeBtnClick()
//}

class FJTabBar: UITabBar {
    
    //如果使用weak修饰代理，需要使用NSObjectProtocol
//    weak var fjdelegate: UITabBarDelegate?
    var closure:()->() = {
        
    }

    override init(frame: CGRect) {
        
       super.init(frame: frame)
        
       setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = ScreenWidth * 0.2
        var index: CGFloat = 0
        
        for value in subviews {
//            let s = NSClassFromString("UITabBarButton")
            if value.isKind(of: NSClassFromString("UITabBarButton")!) {
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                })
                //设置x 和 w
                value.frame.size.width = w
                value.frame.origin.x = index * w
                
                index += 1
                
                if index == 2 {
                    index += 1
                }
            }
        }
        
        composeButton.center.x = frame.size.width * 0.5
        composeButton.center.y = frame.size.height * 0.5 - 14
    }
    
    /*
        必须实现的方法
        如果使用手写代码来创建这个类 就必须实现这个方法
        如果实现init(frame)就代表用手写代码创建
        当如果使用 xib || sb 创建这个类的话，就会提示init(coder:) has not been implemented
        如果要使用xib，在下面的方法加
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
//        super.init(coder: aDecoder)
        
    }
    
    //在OC 运行时 使用 kvc 动态派发的方式调用该方法
    //私有的话，如果没有加 @objc 的话，在运行循环的时候，根本找不到按钮点击的方法
    //这样就是告知系统，使用OC消息运行来调用
    @objc private func btnClick() {
        
//        fjdelegate?.tabBarWithComposeBtnClick()
        closure()
    }
    
    private func setupUI() {
        
        addSubview(composeButton)
    }
    
    private lazy var composeButton: UIButton = {
        let button = UIButton(setImageName: "tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button", target: self, action: #selector(btnClick))
        
        return button
    }()

}
