//
//  HMStatusModel.swift
//  VVeibo21
//
//  Created by Apple on 18/10/26.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
// MARK: - 模型属性
class FJStatusModel: NSObject {
    
    /// 创建时间
    var created_at: Date?
    /// 微博ID
    var id: Int64 = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String?
    /// 用户模型
    var user: FJUserModel?
    /// 转发微博模型
    var retweeted_status:FJStatusModel?
    
    ///int	转发数
    var reposts_count: Int = 0
    /// 评论
    var comments_count: Int = 0
    /// int	表态数
    var attitudes_count: Int = 0
    /// 配图数组
    var pic_urls: [FJPictureInfoModel]?
    
    // 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
    // 类方法 使用 class || static修饰
    class func modelContainerPropertyGenericClass() -> [String: Any] {
        return ["pic_urls": FJPictureInfoModel.self]
    }
    
    override var description: String{
        let keys = ["created_at", "id", "text", "source"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
