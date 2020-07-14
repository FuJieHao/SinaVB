//
//  FJUserAccountModel.swift
//  SInaWeiBo
//
//  Created by Mac on 18/10/28.
//  Copyright © 2018年 haofujie. All rights reserved.
//

import UIKit

class FJUserAccountModel: NSObject,NSCoding {
    
    /// 用户授权的唯一票据
    var access_token: String?
    /// access_token的生命周期，单位是秒数
    var expires_in:TimeInterval = 0{
        // 当expires_in 被赋值的时候就会走 didSet 方法
        didSet{
            // public typealias TimeInterval = Double typealias别名
            // 通过当前日期 + 过期的秒数 = 我们将要过期的日期
            expires_Date = Date().addingTimeInterval(expires_in)
        }
    }
    /// 授权用户的UID
    var uid: String?
    
    /// 用户头像
    var avatar_large: String?
    /// 用户昵称
    var screen_name: String?
    /// 过期时间
    var expires_Date: Date?
    
    override init() {
        super.init()
    }
    
    // 归档
    func encode(with aCoder: NSCoder) {
        self.yy_modelEncode(with: aCoder)
    }
    // 解档
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.yy_modelInit(with: aDecoder)
    }

    override var description: String{
        let keys = ["access_token", "expires_in", "uid", "avatar_large", "screen_name"]
        return dictionaryWithValues(forKeys: keys).description
    }

}
