//
//  HMStatusBottomView.swift
//  VVeibo21
//
//  Created by Apple on 18/10/26.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class FJStatusBottomView: UIView {
    
    var retweetButton: UIButton?
    var commentButton: UIButton?
    var unlikeButton: UIButton?
    
    
    // 定义属性 供外界赋值
    var statusViewModel: FJStatusViewModel?{
        didSet{
            //            //statusViewModel?.statusModel?.reposts_count ?? 0
            //            let repostsCountStr = dealCount(count: 10000, title: "转发")
            //            let commentsCountStr = dealCount(count: statusViewModel?.statusModel?.comments_count ?? 0, title: "评论")
            //            let attitudesStr = dealCount(count: statusViewModel?.statusModel?.attitudes_count ?? 0, title: "赞")
            retweetButton?.setTitle(statusViewModel?.repostsCountStr, for: UIControlState.normal)
            commentButton?.setTitle(statusViewModel?.commentsCountStr, for: UIControlState.normal)
            unlikeButton?.setTitle(statusViewModel?.attitudesStr, for: UIControlState.normal)
        }
    }
    
    
    /*
     - 处理 转发 评论 赞 (业务逻辑)
     
     - 如果 count <= 0 显示 转发 评论 赞
     - 如果 count > 0 && count < 10000  是多少显示多少 例如 7890 显示就是 7890
     - 如果 count >= 10000  显示 x.x 万    例如12000  显示 就是1.2万
     - 例如 20000  显示 2万   30000 显示 3万
     */
    // 处理转发 评论 赞 数
    //    func dealCount(count: Int, title: String) -> String{
    //        if count <= 0 {
    //            return title
    //        }else if count > 0 && count < 10000{
    //            return "\(count)"
    //        }else {
    //            let c = CGFloat(count/1000)/10
    //            var cStr = "\(c)万"
    //
    //            // 如果cStr 包含.0
    //            if cStr.contains(".0") {
    //                // 字符串替换
    //                cStr = cStr.replacingOccurrences(of: ".0", with: "")
    //            }
    //            return cStr
    //        }
    //    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 监听事件
    @objc private func buttonClick(){
//        let vc = FJPingLunViewController()
        
    }

    // MARK: - 设置视图
    private func setupUI(){
//        backgroundColor = RandColor()
        // 01 添加控件
        retweetButton = addChildButtons(imgName: "timeline_icon_retweet", title: "转发")
        commentButton = addChildButtons(imgName: "timeline_icon_comment", title: "评论")
        unlikeButton = addChildButtons(imgName: "timeline_icon_unlike", title: "赞")
        
        let line1 = addChildLines()
        let line2 = addChildLines()
        // 02 添加约束
        
        retweetButton!.snp_makeConstraints { (make) in
            make.top.left.bottom.equalTo(self)
            make.width.equalTo(commentButton!)
        }
        
        commentButton!.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(retweetButton!.snp_right)
            make.width.equalTo(unlikeButton!)
        }
        
        unlikeButton!.snp_makeConstraints { (make) in
            make.top.bottom.right.equalTo(self)
            make.left.equalTo(commentButton!.snp_right)
        }
        
        line1.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(retweetButton!.snp_right)
        }
        
        line2.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(commentButton!.snp_right)
        }
        
    }
    
    // 添加按钮公共方法
    func addChildButtons(imgName: String, title: String) -> UIButton{
        //创建 button
        let button = UIButton(setImageName: imgName, title: title, target: self, action: #selector(buttonClick))
        // 这是背景图
        button.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), for: UIControlState.normal)
        button.setBackgroundImage(UIImage(named: "timeline_card_bottom_background_highlighted"), for: UIControlState.highlighted)
        // 添加 button
        addSubview(button)
        return button
    }
    // 添加分割线
    func addChildLines() -> UIImageView{
        let img = UIImageView(imageName: "timeline_card_bottom_line")
        // 添加控件
        addSubview(img)
        return img
    }
}
