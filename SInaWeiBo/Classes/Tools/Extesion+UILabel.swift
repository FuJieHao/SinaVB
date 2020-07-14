//
//  Extesion+UILabel.swift
//  SInaWeiBo
//
//  Created by Mac on 16/10/23.
//  Copyright © 2016年 haofujie. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(textColor:UIColor, fontSize: CGFloat, text: String, maxWidth: CGFloat = 0) {
        self.init()
        
        self.text = text
        
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textColor = textColor
        
        if maxWidth > 0 {
            // 指定最大显示的宽度
            self.preferredMaxLayoutWidth = maxWidth
            // 换行
            self.numberOfLines = 0
            
        }
    }
}
