//
//  Common.swift
//  SInaWeiBo
//
//  Created by Mac on 18/10/22.
//  Copyright © 2018年 haofujie. All rights reserved.
//

import UIKit

//  点击表情按钮通知名
let DidSelectedEmoticonButtonNotification = "DidSelectedEmoticonButtonNotification"
//  点击删除表情按钮的通知
let DidSelectedDeleteEmotionButtonNotification = "DidSelectedDeleteEmotionButtonNotification"

// 微博中需要使用的通知名字
let HMSWITCHROOTVCNOTI = "HMSWITCHROOTVCNOTI"

let ScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let ScreenHeight: CGFloat = UIScreen.main.bounds.size.height
func RandColor() -> UIColor{
    let r = CGFloat(arc4random()%256)
    let g = CGFloat(arc4random()%256)
    let b = CGFloat(arc4random()%256)
    return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
}


let BigFontSize:CGFloat = 18
let NormalFontSize:CGFloat = 14
let SmallFontSize:CGFloat = 12

//微博的相关信息
let FJAppKey = "3929731360"
let FJAppSecret = "e4468e1be327b8e12ed60e0823e4e331"
//回调页
let FJRedirectUrl = "http://sns.whalecloud.com/sina2/callback"

//微博账号和密码
let FJWeiBoName = "18942600840"
let FJWeiBoPassword = "3781389"

