//
//  HMComposeToolBar.swift
//  VVeibo21
//
//  Created by Apple on 18/11/2.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

enum FJEmoticonToolBarButtonType: Int {
    //  最近表情
    case recent = 1000
    //  默认表情
    case normal = 1001
    //  emoji
    case emoji = 1002
    //  浪小花
    case lxh = 1003
}

//  表情键盘 toolbar 视图
class FJEmoticonToolBar: UIStackView {

    //记录上一次选中的按钮
    var lastSelectedButton: UIButton?
    
    //为了点击toolBar使上面的cell切换，搞一个闭包使使
    var callBack: ((FJEmoticonToolBarButtonType) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        //  设置布局方式
        axis = .horizontal
        //  设置子控件填充方式
        distribution = .fillEqually
    
        addChildButton(imageName: "compose_emotion_table_left", title: "最近" ,type: .recent)
        addChildButton(imageName: "compose_emotion_table_mid", title: "默认" ,type: .normal)
        addChildButton(imageName: "compose_emotion_table_mid", title: "Emoji" ,type: .emoji)
        addChildButton(imageName: "compose_emotion_table_right", title: "浪小花" ,type: .lxh)
        
    }
    
    //  添加子按钮操作
     private func addChildButton(imageName: String, title: String, type: FJEmoticonToolBarButtonType) {
    
        let button = UIButton()
        
        //在创建的时候给定tag值
        button.tag = type.rawValue
        
        //  添加点击事件
        button.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside)
        
        //  设置不同状态下的背景图片
        button.setBackgroundImage(UIImage(named: imageName + "_normal"), for: .normal)
        button.setBackgroundImage(UIImage(named: imageName + "_selected"), for: .selected)
    
        //  设置不同状态下的文字颜色
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.gray, for: .selected)
        
        //  设置字体大小
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle(title, for: .normal)
        
        //  取消高亮效果
        button.adjustsImageWhenHighlighted = false
        
        addArrangedSubview(button)
        
        if type == .normal {
            lastSelectedButton?.isSelected = false
            button.isSelected = true
            lastSelectedButton = button
        }
    }
    
    @objc private func buttonAction(btn: UIButton) {
        
        //如果点击的按钮和上一次选中的按钮相同，那么可以直接返回
        if lastSelectedButton == btn {
            return
        }
        
        //否则的话
        //上一次选中的按钮选中状态改成 false
        lastSelectedButton?.isSelected = false
        //当前点击按钮的选中状态为true
        btn.isSelected = true
        //记录当前选中的按钮
        lastSelectedButton = btn
        
        //通过tag获取对应按钮的枚举值，这样的好处是我在外面switch的时候，玩的是枚举，不是数字
        let type = FJEmoticonToolBarButtonType(rawValue: btn.tag)!
        
        //执行个闭包
        callBack?(type)
    }
    
    //  根据 section 选中对应的按钮
    func selectedButtonWithSection(section: Int)  {
        //  以后设置 tag 的时候尽量不用从0开始,否则取值的时候去的不是这个空间,而是当前对象自己
        let button = viewWithTag(section + 1000) as! UIButton
        
        if lastSelectedButton == button {
            return
        }
        
        lastSelectedButton?.isSelected = false
        
        button.isSelected = true
        
        lastSelectedButton = button
        
    }
    
}
