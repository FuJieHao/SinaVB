//
//  FJWelcomeViewController.swift
//  VVeibo21
//
//  Created by Apple on 18/10/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import SDWebImage
class FJWelcomeViewController: UIViewController {
    
    override func loadView() {
        view = bgImageView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 设置headImageView 动画
        // 01 修改headImageView 约束 top
        /*
         snp_updateConstraints(如果约束的对象 相对约束参考物没有发生改变)
         */
        self.headImageView.snp_updateConstraints { (make) in
            make.top.equalTo(self.view).offset(100)
        }
        
        // 02 设置动画(阻尼动画)
        /*
         - withDuration: 动画时长
         - delay: 延迟时间
         - Damping: 阻尼系数(范围0-1) 阻尼系数越小 弹性效果越好
         - initialSpringVelocity: 起始加速度
         -
         */
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            /*
             - 动画是基于 frame 而当前使用的是约束
             解决问题: 需要重新刷新布局
             */
            self.view.layoutIfNeeded()
        }) { (_) in
            // 头像嘚瑟完成
            // 欢迎回来要显示
            UIView.animate(withDuration: 0.25, animations: {
                self.messageLabel.alpha = 1
                }, completion: { (_) in
                    // 发通知切换根控制器04
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: HMSWITCHROOTVCNOTI), object: "welcomeVc")
            })
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - 设置视图
    private func setupUI(){
        // 01 添加控件
        view.addSubview(headImageView)
        view.addSubview(messageLabel)
        // 02 添加约束
        headImageView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 90, height: 90))
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(400)
        }
        
        messageLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(headImageView.snp_bottom).offset(16)
        }
    }

    
    // MARK: - 懒加载控件
    // 背景图片
    private lazy var bgImageView: UIImageView = UIImageView(imageName: "ad_background")
    // 用户头像
    private lazy var headImageView: UIImageView = {
        let img = UIImageView()
        img.layer.borderColor = UIColor.orange.cgColor
        img.layer.borderWidth = 1
        img.layer.cornerRadius = 45
        img.layer.masksToBounds = true
//        let url = URL(string: HMUserAccountViewModel.sharedTools.userAccountModel?.avatar_large ?? "")!
////        img.test("imgURL","IMGNAME")
//        img.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"))
        img.sd_setImage(with: URL(string:(FJUserAccountViewModel.sharedTools.userAccountModel?.avatar_large)!), placeholderImage: UIImage(named: "avatar_default_big"))
        
        return img
    }()
    // 欢迎回来
    private lazy var messageLabel: UILabel = {
        let lab = UILabel(textColor: UIColor.orange, fontSize: 18, text: "欢迎回来")
        // 对齐方式
        lab.textAlignment = .center
        lab.alpha = 0
        return lab
    }()

}
