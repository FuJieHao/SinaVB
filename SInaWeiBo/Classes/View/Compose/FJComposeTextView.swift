//
//  HMComposeTextView.swift
//  VVeibo21
//
//  Created by Apple on 18/11/1.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

//  自定义 UITextView
class FJComposeTextView: UITextView {

    // MARK: - 懒加载控件
    fileprivate lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "听说下雨天音乐跟辣条更配哟~"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.lightGray
        //  设置多行显示
        label.numberOfLines = 0
        return label
    }()
    //  提供设置占位文字属性
    var placeHolder: String? {
        didSet {
            placeHolderLabel.text = placeHolder
        }
    }
    //  重写 font 属性设置占位 label 的 font 属性
    override var font: UIFont? {
        didSet {
            if font != nil {
                placeHolderLabel.font = font!
            }
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        //  监听文字改变的通知
        NotificationCenter.default.addObserver(self, selector: #selector(textChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
        //  添加控件设置约束
        addSubview(placeHolderLabel)
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: placeHolderLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: placeHolderLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 6))
        addConstraint(NSLayoutConstraint(item: placeHolderLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: -10))
        
    
    }
    
    //  监听文字改变的通知方法
    @objc private func textChange() {
        //  根据文本框里面是否有内容,判断是否显示和隐藏占位 label
        placeHolderLabel.isHidden = hasText
    
    }
    
    deinit {
        //  移除通知
        NotificationCenter.default.removeObserver(self)
    }
    

}
