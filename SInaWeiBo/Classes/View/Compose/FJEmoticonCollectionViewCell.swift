//
//  HMEmoticonCollectionViewCell.swift
//  VVeibo21
//
//  Created by Apple on 18/11/2.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
//  表情视图 cell
class FJEmoticonCollectionViewCell: UICollectionViewCell {
    
    var emoticonArray: [FJEmoticon]? {
        
        didSet {
            //设置数据的时候绑定表情按钮的数据
            guard let etnArray = emoticonArray else {
                return
            }
            
            //解决cell复用的套路
            //先把按钮全部隐藏，在绑定数据的时候在设置显示
            for button in emoticonButtonArray {
                button.isHidden = true
            }
            
            for (i,emoticon) in etnArray.enumerated() {
                
                //根据下标获取对应的表情按钮
                let emoticonButton = emoticonButtonArray[i]
                
                //把模型和按钮进行绑定
                emoticonButton.emoticon = emoticon
                
                emoticonButton.isHidden = false
                if emoticon.type == "0" {
                    //表示图片(要的就是全路径)
                    emoticonButton.setImage(UIImage(named:emoticon.fullPath!), for: .normal)
   
                    emoticonButton.setTitle(nil, for: .normal)
                    
                } else {
                    
                    //表示 emoji
                    emoticonButton.setTitle((emoticon.code! as NSString).emoji(), for: .normal)
                    emoticonButton.setImage(nil, for: .normal)
                    
                }
            }
        }
        
    }
    
    //存储20个表情按钮
    fileprivate lazy var emoticonButtonArray: [FJEmoticonButton] = [FJEmoticonButton]()
    
    //  删除表情按钮
    fileprivate lazy var deleteEmoticonButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(deleteEmoticonButtonAction), for: .touchUpInside)
        button.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
        button.setImage(UIImage(named: "compose_emotion_delete_highlighted"), for: .highlighted)
        return button
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  添加控件设置约束
    private func setupUI() {
    
        addChildButton()
        addSubview(deleteEmoticonButton)
    }
    
    // MARK: - 点击删除表情按钮逻辑处理
    @objc private func deleteEmoticonButtonAction() {
        //  执行删除表情内容的操作
        NotificationCenter.default.post(name: NSNotification.Name(DidSelectedDeleteEmotionButtonNotification), object: nil)
        
    }
    
    //后面的思路就是先添加上按钮，  然后在layout里进行布局（我需要关注一下执行顺序)
    
    //添加表情按钮
    
    private func addChildButton() {
        
        for _ in 0..<20 {
            
            let button = FJEmoticonButton()
            
            button.addTarget(self, action: #selector(emoticonButtonAction(btn:)), for: .touchUpInside)
            
            button.titleLabel?.font = UIFont.systemFont(ofSize: 33)
            contentView.addSubview(button)
            
            //用数组存起来这些按钮
            emoticonButtonArray.append(button)
        }
    }
    
    //点击表情事件处理
    @objc private func emoticonButtonAction(btn: FJEmoticonButton) {
        
        //获取按钮对应的表情模型
        let emoticon = btn.emoticon
        
        //发送点击表情按钮的通知
        NotificationCenter.default.post(name: NSNotification.Name(DidSelectedEmoticonButtonNotification), object: emoticon, userInfo: nil)
    }
    
    //布局按钮的位置
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //计算表情按钮的宽度/高度
        let buttonWidth = width / 7
        let buttonHeight = height / 3
        
        //设置按钮的frame
        for (i,button) in emoticonButtonArray.enumerated() {
            
            //计算列的索引
            let colIndex = i % 7
            //计算行的索引
            let rowIndex = i / 7
            
            //计算x,y坐标
            button.x = CGFloat(colIndex) * buttonWidth
            button.y = CGFloat(rowIndex) * buttonHeight
            
            button.size = CGSize(width: buttonWidth, height: buttonHeight)
        }
        
        //  设置删除按钮的大小
        deleteEmoticonButton.size = CGSize(width: buttonWidth, height: buttonHeight)
        //  设置 x,y 坐标
        deleteEmoticonButton.x = width - buttonWidth
        deleteEmoticonButton.y = height - buttonHeight
    }
}
