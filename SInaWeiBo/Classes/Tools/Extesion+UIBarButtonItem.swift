//
//  Extesion+UIBarButtonItem.swift
//  SInaWeiBo
//
//  Created by Mac on 16/10/22.
//  Copyright © 2016年 haofujie. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
//    convenience init(setImageName:String ,target:Any? ,action:Selector) {
//        self.init()
//        
//        let barButtonItem = UIButton(setImageName: setImageName, target: target, action: action)
//        
//        self.customView = barButtonItem
//    }
    
    convenience init(setImageName:String? = nil , title: String? = nil,target:Any? ,action:Selector) {
        self.init()
        
        let barButtonItem = UIButton(setImageName: setImageName, title: title, target: target, action: action)
        
        self.customView = barButtonItem
    }
}
