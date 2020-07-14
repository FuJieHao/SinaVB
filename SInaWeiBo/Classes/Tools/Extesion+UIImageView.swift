//
//  Extesion+UIImageView.swift
//  SInaWeiBo
//
//  Created by Mac on 16/10/23.
//  Copyright © 2016年 haofujie. All rights reserved.
//

import UIKit

extension UIImageView {
    
    convenience init(imageName: String) {
        self.init(image:UIImage(named: imageName))
    }
}
