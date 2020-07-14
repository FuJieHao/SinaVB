//
//  HMStatusRetweetView.swift
//  VVeibo21
//
//  Created by Apple on 18/10/26.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class FJStatusRetweetView: UIView {
    
    // 记录约束
    var retweetViewCons: Constraint?
    
    // 定义属性 供外界赋值
    var statusViewModel: FJStatusViewModel?{
        didSet{
            // 转发正文
            contentLabel.attributedText = statusViewModel?.retweetAttributedStr
            
            // 卸载约束
            /*
             - 如果配图数组. count > 0 就代表有配图
             - 赋值
             - 显示配图
             - 转发微博的 bottom == 配图的 bottom
             0 如果没有配图
             - 隐藏配图
             - 转发微博的 bottom == 文字的bottom
             */
            // 卸载约束
            retweetViewCons?.uninstall()
            // 有配图
            if statusViewModel?.statusModel?.retweeted_status?.pic_urls != nil {
                if (statusViewModel?.statusModel?.retweeted_status?.pic_urls?.count)! > 0 {
                    pictureView.picUrls = statusViewModel?.statusModel?.retweeted_status?.pic_urls
                    pictureView.isHidden = false
                    
                    self.snp_makeConstraints { (make) in
                        self.retweetViewCons = make.bottom.equalTo(pictureView).offset(10).constraint
                    }
                }else {
                    // 没有配图
                    pictureView.isHidden = true
                    self.snp_makeConstraints { (make) in
                        self.retweetViewCons = make.bottom.equalTo(contentLabel).offset(10).constraint
                    }
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 设置视图
    private func setupUI(){
//        backgroundColor = RandColor()
        backgroundColor = UIColor.groupTableViewBackground
        // 01 添加控件
        addSubview(contentLabel)
         addSubview(pictureView)
        // 02 添加约束
        contentLabel.snp_makeConstraints { (make) in
            make.top.left.equalTo(10)
        }
        
        pictureView.snp_makeConstraints { (make) in
//            make.size.equalTo(CGSize(width: 100, height: 100))
            make.left.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp_bottom).offset(10)
        }
        
        self.snp_makeConstraints { (make) in
            self.retweetViewCons = make.bottom.equalTo(pictureView).offset(10).constraint
        }

    }

    // MARK: - 懒加载控件
    // 转发正文
//    private lazy var contentLabel: UILabel = UILabel(textColor: UIColor.darkGray, fontSize: NormalFontSize, text: "设置视图设置视图设置视图设置视图设置视图设置视图设置视图设置视图设置视图设置视图设置视图设置视图设置视图设置视图设置视图", maxWidth: ScreenWidth - 20)
    private lazy var contentLabel: YYLabel = {
        let label = YYLabel()
        //  指定最大换行宽度
        label.preferredMaxLayoutWidth = ScreenWidth - 20
        //  多行显示
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var pictureView: FJStatusPictrueView = {
        let view = FJStatusPictrueView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
}
