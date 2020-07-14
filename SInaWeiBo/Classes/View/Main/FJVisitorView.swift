//
//  FJVisitorView.swift
//  SInaWeiBo
//
//  Created by Mac on 18/10/23.
//  Copyright © 2018年 haofujie. All rights reserved.
//

import UIKit

class FJVisitorView: UIView {
    
    //监听访客视图 回调给控制器，四个按钮公用一个方法的设想
    var closure: ()->() = {
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupVisitorViewInfo(imageName: String? ,title: String?) {
        
        if let img = imageName, let tit = title {
            iconImageView.image = UIImage(named: img)
            messageLabel.text = tit
            
            //隐藏圆圈
            circleImageView.isHidden = true
        } else {
            //否则的话就是首页，要在里面执行转圈圈的动画
            setupCircleImageViewAnim()
        }
    }
    
    private func setupCircleImageViewAnim () {
        // 核心动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        // 设置转的角度
        anim.toValue = M_PI * 2
        // 设置时间
        anim.duration = 20
        // 重复次数
        anim.repeatCount = MAXFLOAT
        // 完成以后是否移除动画
        /*
         - 如果你切换控制器 或者程序推到后台 默认情况下动画会被移除
         - 解决办法 isRemovedOnCompletion = false
         */
        anim.isRemovedOnCompletion = false
        // 添加动画
        circleImageView.layer.add(anim, forKey: nil)
    }
    
    private func setupUI() {
        backgroundColor = UIColor(white: 237/255.0, alpha: 1)
        
        addSubview(iconImageView)
        
        //添加约束 (使用系统自带的方法）
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        
        addSubview(circleImageView)
        addSubview(maskImageView)
        
        addSubview(messageLabel)
        
        addSubview(registerBtn)
        addSubview(loginBtn)
        
        circleImageView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
        }
        maskImageView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        messageLabel.snp_makeConstraints { (make) in
            make.width.equalTo(230)
            make.centerX.equalTo(self)
            make.top.equalTo(maskImageView.snp_bottom).offset(16)
        }
        
        // 05注册按钮
        registerBtn.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 100, height: 35))
            make.left.equalTo(messageLabel)
            make.top.equalTo(messageLabel.snp_bottom).offset(16)
        }
        
        // 07登录按钮
        loginBtn.snp_makeConstraints { (make) in
            make.size.top.equalTo(registerBtn)
            make.right.equalTo(messageLabel)
        }

        
    }
    
    private lazy var iconImageView: UIImageView = UIImageView(imageName: "visitordiscover_feed_image_house")
    private lazy var circleImageView: UIImageView = UIImageView(imageName: "visitordiscover_feed_image_smallicon")
    
    //遮罩
    private lazy var maskImageView: UIImageView = UIImageView(imageName: "visitordiscover_feed_mask_smallicon")
    
    private lazy var messageLabel :UILabel = {
        let lab = UILabel(textColor: UIColor.darkGray, fontSize: NormalFontSize, text: "关注一些人，回这里看看有什么惊喜关注一些人，回这里看看有什么惊喜")
       
        lab.textAlignment = .center
        
        lab.numberOfLines = 0
        
        return lab
    }()
    
    @objc private func regisBtnClick () {
        
        closure()
    }
    
    //懒加载下面的两个按钮
    private lazy var registerBtn: UIButton = UIButton(setBackgroundImageName: "common_button_white", title: "注册", fontSize: NormalFontSize, titleColor: UIColor.orange, target: self, action: #selector(regisBtnClick))
    private lazy var loginBtn: UIButton = UIButton(setBackgroundImageName: "common_button_white", title: "登录", fontSize: NormalFontSize, titleColor: UIColor.orange, target: self, action: #selector(regisBtnClick))
}

// private 如果使用其修饰 即使是自己的分类也无法调用，解决办法，改为fileprivate 即可
