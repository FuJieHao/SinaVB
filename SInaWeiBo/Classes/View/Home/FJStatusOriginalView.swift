//
//  FJStatusOriginalView.swift
//  SInaWeiBo
//
//  Created by Mac on 18/10/31.
//  Copyright © 2018年 haofujie. All rights reserved.
//

import UIKit

class FJStatusOriginalView: UIView {
    
    // 记录原创微博的底部约束
    var originalViewBottomeCons: Constraint?
    
    // 定义一个属性 ViewModel 供外界赋值
    var statusViewModel: FJStatusViewModel?{
        didSet{
            // 当前的控件赋值了
            // 头像
            headImageView.sd_setImage(with: URL(string:statusViewModel?.statusModel?.user?.profile_image_url ?? ""), placeholderImage: UIImage(named: "avatar_default_big"))
            // 昵称
            nameLabel.text = statusViewModel?.statusModel?.user?.name
            // 等级
            membershipImageView.image = statusViewModel?.mbrankImage
            // 认证
            avatarImageView.image = statusViewModel?.verifiedImage
            // 微博正文
            contentLabel.attributedText = statusViewModel?.originalAttributedStr
            
            
            sourceLabel.text = statusViewModel?.sourceStr
            
            timeLabel.text = statusViewModel?.timeStr
            
            // 配图赋值
            
            /*
             - 先卸载约束
             - 判断的临界条件 count > 0 就代表有图片
             - 赋值
             - 显示配图
             - 原创微博的底部 == 配图的底部 +10
             - 反之没有图片
             - 隐藏配图
             - 原创微博的底部 == 文字的底部 + 10
             */
            // 卸载约束
            originalViewBottomeCons?.uninstall()
            // 有配图
            if (statusViewModel?.statusModel?.pic_urls?.count)! > 0 {
                pictureView.picUrls = statusViewModel?.statusModel?.pic_urls
                pictureView.isHidden = false
                self.snp_makeConstraints { (make) in
                    self.originalViewBottomeCons = make.bottom.equalTo(pictureView).offset(10).constraint
                }
                
            }else {
                // 没有配图
                pictureView.isHidden = true
                self.snp_makeConstraints { (make) in
                    self.originalViewBottomeCons = make.bottom.equalTo(contentLabel).offset(10).constraint
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
        // 01 - 添加控件
        addSubview(headImageView)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(membershipImageView)
        addSubview(avatarImageView)
        addSubview(contentLabel)
        addSubview(pictureView)
        
        
        // 02 - 添加约束
        headImageView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.top.left.equalTo(10)
        }
        
        nameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(headImageView)
            make.left.equalTo(headImageView.snp_right).offset(10)
        }
        
        timeLabel.snp_makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.bottom.equalTo(headImageView)
        }
        
        sourceLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(timeLabel)
            make.left.equalTo(timeLabel.snp_right).offset(10)
        }
        
        membershipImageView.snp_makeConstraints { (make) in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp_right).offset(10)
        }
        
        avatarImageView.snp_makeConstraints { (make) in
            make.centerX.equalTo(headImageView.snp_right).offset(-3)
            make.centerY.equalTo(headImageView.snp_bottom).offset(-3)
        }
        
        contentLabel.snp_makeConstraints { (make) in
            make.top.equalTo(headImageView.snp_bottom).offset(10)
            make.left.equalTo(headImageView)
            //            make.right.equalTo(self).offset(-10)
//            make.bottom.equalTo(self).offset(-10)
        }
        
        pictureView.snp_makeConstraints { (make) in
            //            make.size.equalTo(CGSize(width: 100, height: 100))
            make.top.equalTo(contentLabel.snp_bottom).offset(10)
            make.left.equalTo(contentLabel)
        }
        
        self.snp_makeConstraints { (make) in
            self.originalViewBottomeCons = make.bottom.equalTo(pictureView).offset(10).constraint
        }
        
        headImageView.layer.masksToBounds = true
        headImageView.layer.cornerRadius = 40 * 0.5

    }
    
    // MARK: - 懒加载控件
    // 01 头像
    private lazy var headImageView: UIImageView = UIImageView(imageName: "avatar_default_big")
    // 02 昵称
    private lazy var nameLabel: UILabel = UILabel(textColor: UIColor.blue, fontSize: NormalFontSize, text: "老宋")
    // 03 时间
    private lazy var timeLabel: UILabel = UILabel(textColor: UIColor.orange, fontSize: SmallFontSize, text: "时间")
    // 04 来源
    private lazy var sourceLabel: UILabel = UILabel(textColor: UIColor.orange, fontSize: SmallFontSize, text: "来自iPhone 7s plus")
    // 05 微博等级
    private lazy var membershipImageView: UIImageView = UIImageView(imageName: "common_icon_membership")
    // 06 认证
    private lazy var avatarImageView: UIImageView = UIImageView(imageName: "avatar_vgirl")
    // 07 微博正文
    private lazy var contentLabel: YYLabel = {
        
        let label = YYLabel()
        
        //指定最大换行宽度
        label.preferredMaxLayoutWidth = ScreenWidth - 20
        //多行显示
        label.numberOfLines = 0
        
        return label
        
    }()
    // 08 - 配图
    private lazy var pictureView: FJStatusPictrueView = {
        let view =  FJStatusPictrueView()
        view.backgroundColor = self.backgroundColor
        return view
    }()
}





