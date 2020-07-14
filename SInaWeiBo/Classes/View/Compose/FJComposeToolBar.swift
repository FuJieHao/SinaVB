//
//  FJComposeToolBar.swift
//  SInaWeiBo
//
//  Created by Mac on 18/11/1.
//  Copyright © 2018年 haofujie. All rights reserved.
//

import UIKit

enum FJComposeToolBarButtonType: Int {
    //  图片
    case picture = 0
    // @
    case mention = 1
    // #
    case trend = 2
    //  表情
    case emoticon = 3
    //  加号
    case add = 4
}

//自定义发微博， toolBar视图
// 注意：UIStackView 自身不具备渲染效果，颜色是由其子控件提供的，它只是一个容器
class FJComposeToolBar: UIStackView {
    
    //按钮的点击闭包
    var callBack: ((FJComposeToolBarButtonType)->())?
    
    //表情按钮
    var emoticonButton: UIButton?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        //设置水平方向的布局
        axis = .horizontal
        //设置子控件的填充方式
        distribution = .fillEqually
        
        addChildButton(imageName: "compose_camerabutton_background", type: .picture)
        addChildButton(imageName: "compose_mentionbutton_background", type: .mention)
        addChildButton(imageName: "compose_trendbutton_background", type: .trend)
        emoticonButton =  addChildButton(imageName: "compose_emoticonbutton_background", type: .emoticon)
        addChildButton(imageName: "compose_add_background", type: .add)
    }
    
    
    @discardableResult//这是忽略返回结果的设置
    //添加子按钮,为了对所点击按钮进行区分，所以用tag，为了更便于认识，用枚举代替tag
    private func addChildButton(imageName: String, type:FJComposeToolBarButtonType) -> UIButton {
        
        let button = UIButton()
        
        //可以把枚举的原始值作为Button的tag使用
        button.tag = type.rawValue
        
        button.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        button.setBackgroundImage(UIImage(named: "compose_toolbar_background"), for: .normal)
        
        //adjust调整的意思，这句话的意思就是我不需要调整高亮效果，就是说我是没有高亮的
        button.adjustsImageWhenHighlighted = false
        
        //添加子控件
        addArrangedSubview(button)
        
        return button
    }
    
    //按钮的点击事件
    @objc private func buttonAction(btn: UIButton) {
        
       let type = FJComposeToolBarButtonType(rawValue: btn.tag)!
        
       callBack?(type)
    }
    
    //根据是否是表情键盘类型切换不同的icon
    func showIcon(isEmotion:Bool) {
        
        /*
         
         逻辑就是如果是表情键盘类型，显示系统的icon
         如果是系统键盘的类型，显示表情的icon
         
         */
        
        if isEmotion {
            //  表示表情键盘,显示系统键盘的 icon
            emoticonButton?.setImage(UIImage(named: "compose_keyboardbutton_background"), for: .normal)
            emoticonButton?.setImage(UIImage(named: "compose_keyboardbutton_background_highlighted"), for: .highlighted)
        } else {
            //  表示系统键盘,显示表情键盘的 icon
            emoticonButton?.setImage(UIImage(named: "compose_emoticonbutton_background"), for: .normal)
            emoticonButton?.setImage(UIImage(named: "compose_emoticonbutton_background_highlighted"), for: .highlighted)
        }

        
    }

}







