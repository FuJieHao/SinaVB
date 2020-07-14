//
//  Extesion+UIButton.swift
//  SInaWeiBo
//
//  Created by Mac on 16/10/22.
//  Copyright © 2016年 haofujie. All rights reserved.
//

import UIKit

extension UIButton {
    
   convenience init(setImageName:String ,backgroundImageName:String ,target:Any? ,action:Selector) {
        self.init()
        
        self.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        
        self.setImage(UIImage(named:setImageName), for: UIControlState.normal)
        self.setImage(UIImage(named:"\(setImageName)_highlighted"), for: UIControlState.highlighted)
    
        self.setBackgroundImage(UIImage(named:backgroundImageName), for: UIControlState.normal)
        self.setBackgroundImage(UIImage(named:"\(backgroundImageName)_highlighted"), for: UIControlState.highlighted)
        
        self.sizeToFit()
    }
    
    convenience init(setImageName:String? = nil , title: String? = nil,target:Any? ,action:Selector) {
        self.init()
        
        self.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        
        if let img = setImageName {
            self.setImage(UIImage(named:img), for: UIControlState.normal)
            self.setImage(UIImage(named:"\(img)_highlighted"), for: UIControlState.highlighted)
        }
        
        if let tit = title {
            self.setTitle(tit, for: UIControlState.normal)
            self.setTitleColor(UIColor.gray, for: UIControlState.normal)
            self.setTitleColor(UIColor.orange, for: UIControlState.highlighted)
            self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        
        self.sizeToFit()
    }
    
    convenience init(setBackgroundImageName:String? = nil , title: String? = nil, fontSize: CGFloat, titleColor: UIColor, target:Any? ,action:Selector) {
        self.init()
        
        self.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        
        if let img = setBackgroundImageName {
            self.setBackgroundImage(UIImage(named:img), for: UIControlState.normal)
        }
        
    
        self.setTitle(title, for: UIControlState.normal)
        self.setTitleColor(titleColor, for: UIControlState.normal)
        self.titleLabel?.font = UIFont(name: title!, size: fontSize)
        
        self.sizeToFit()
    }
    
    
}
