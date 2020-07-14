//
//  FJEmoticon.swift
//  SInaWeiBo
//
//  Created by Mac on 18/11/2.
//  Copyright © 2018年 haofujie. All rights reserved.
//

import UIKit

/*
 通过观察那个bundle包，处理的方式就是，舍弃掉动态图，将多个表情块公用一个模型
 
 */
class FJEmoticon: NSObject,NSCoding {
    
    //表情描述 -> 给服务器端需要发送的是这个字段
    var chs: String?
    //表情图片名称
    var png: String?
    //表情的类型 //通过这个类型来区别表情的类型
    var type: String?
    // 16进制字符串（是用来处理emoji表情的)
    var code: String?
    
    // 图片全路径
    var fullPath: String?
    //保存图片对应的文件夹
    var folderName: String?
    
    //  重写默认的构造函数
    override init() {
        super.init()
    }
    
    
    // MARK: - 归档和解档
    //  归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(chs, forKey: "chs")
        aCoder.encode(png, forKey: "png")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(code, forKey: "code")
        aCoder.encode(fullPath, forKey: "fullPath")
        aCoder.encode(folderName, forKey: "folderName")
    }
    //  解档
    required init?(coder aDecoder: NSCoder) {
        chs = aDecoder.decodeObject(forKey: "chs") as? String
        png = aDecoder.decodeObject(forKey: "png") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        code = aDecoder.decodeObject(forKey: "code") as? String
        fullPath = aDecoder.decodeObject(forKey: "fullPath") as? String
        folderName = aDecoder.decodeObject(forKey: "folderName") as? String
        
        if type == "0" {
            //  如果是图片表情,那么重新修改图片全路径
            let path = FJEmoticonTool.shareTool.emoticonsBundle.path(forResource: folderName, ofType: nil)! + "/" + png!
            //  设置全路径
            fullPath = path
            
        }

    }

}
