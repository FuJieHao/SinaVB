//
//  FJUserAccountViewModel.swift
//  SInaWeiBo
//
//  Created by Mac on 18/10/28.
//  Copyright © 2018年 haofujie. All rights reserved.
//

import UIKit

class FJUserAccountViewModel {
    
    // 使用很频繁 当前 app 中可能多个模块均需要使用
    // 全局访问点
    static let sharedTools: FJUserAccountViewModel = FJUserAccountViewModel()
    
    //定义用户信息对象,这里定义这个用户信息对象，目的是为了防止频繁操纵沙盒
    var userAccountModel: FJUserAccountModel?
    
    // 路径
    let file = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString).appendingPathComponent("userAccount.archiver")
    
    /*
     accessToken 后期我们会频繁使用它 但是他是有过期的时间(开发者用户 过期时间5年 普通用户是三天)
     - 01 如果用户第一次登陆 -> 没有保存过个人信息数据 accessToken == nil
     - 02 如果用户登陆过 但是 例如他是普通用户 20170101 -> 20170104 -> 如果你在20170105 代表他已经过期了 -> 他还会使用accessToken -> 程序员accessToken == nil   -> 告知用户重新登陆
     - 03 accessToken==nil 要不没有登录 要不就是过期了\
     
     - 分析他accessToken 是存储型属性 还是计算型属性
     - 每次使用之前 都需要判断 实时判断 才能真正的保证他是否过期
     */

    /// 判断用户是否登录
    /*
     - 如果用户登录 (用户登录了 而且没有过期)
     - 如果用户没有登录(真的没有登录过 , 用户登录过 但是过期了)
     - 需要每次使用均需要判断下 所以使用计算型属性
     */
    
    var isLogin:Bool {
        return accessToken != nil
    }
    
    /// 访问令牌
    var accessToken:String?{
        // 代表用户登录过 而且保存过数据
        // 需要判断是否过期了么
        // 如果过期时间和当前时间比较 == 降序 代表没有过期
        /*
         - 为什么简写: 因为如果userAccountModel==nil 在和当前时间比较 也不会满足条件的如果可以直接简写
         */
        if userAccountModel?.expires_Date?.compare(Date()) == ComparisonResult.orderedDescending {
            return userAccountModel?.access_token
        }else {
            return nil
        }
    }

    
    // 没有继承的类 也需要实现 init 方法(如果外界调用sharedTools 就会走 init 方法 我们需要给单例对象身上userAccountModel 赋值)
    init() {
        // 用户模型赋值
        userAccountModel = getUserAccountModel()
    }
}

extension FJUserAccountViewModel {
    
    //获取 token
    func getUserAccount(code: String, finish:@escaping (Bool)->()) {
        
        FJNetworking.sharedTools.oauthLoadUserAccount(code: code, success: { (response) in
            
            //判断response 是否为Nil 而且是否可以转换成字典
            //guard 或者 if-let 判断就是可选值 如果转成想要的类型 需要使用 as?
            
            guard let res = response as? [String:Any] else {
                finish(false)
                return
            }
            //字典转模型
            let userAccountModel = FJUserAccountModel.yy_model(withJSON: res)
            
            // 判断userAccountModel 不为 nil
            guard let model = userAccountModel else {
                finish(false)
                return
            }
            
            self.getUserInfo(model: model,finish:finish)
            
            
            }) { (error) in
                finish(false)
                print("请求失败")
        }
    }
    
    //请求用户信息
    func getUserInfo(model: FJUserAccountModel, finish:@escaping (Bool)->()) {
        
        
        FJNetworking.sharedTools.oauthLoadUserInfo(model: model, success: { (response) in
            
            // 判断response 是否为 nil 而且是否可以转成一个字典
            guard let res = response as?[String: Any] else{
                finish(false)
                return
            }
            
            model.screen_name = res["screen_name"] as? String
            model.avatar_large = res["avatar_large"] as? String
            
            // 保存模型
           self.saveUserAccountModel(model: model)
            finish(true)
        }) { (error) in
            finish(false)
            print("请求失败",error)
        }
        
    }

}


extension FJUserAccountViewModel {
    
    // 保存用户信息对象
    func saveUserAccountModel(model: FJUserAccountModel){
        
        // 因为首次使用该类的时候 会走 init 方法 但是我们第一次登陆 app 根本没有保存过个人信息数据 导致userAccountModel 为 nil
        // 解决方法 需要外界调用该方法保存用户对象的时候 程序员手动给单例对象的userAccountModel 赋值
        userAccountModel = model
        
        
        NSKeyedArchiver.archiveRootObject(model, toFile: file)
    }
    // 获取用户信息对象
    func getUserAccountModel() ->FJUserAccountModel?{
        let result = NSKeyedUnarchiver.unarchiveObject(withFile: file) as? FJUserAccountModel
        return result
    }

}
