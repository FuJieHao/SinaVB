//
//  FJNetworking.swift
//  SInaWeiBo
//
//  Created by Mac on 18/10/28.
//  Copyright © 2018年 haofujie. All rights reserved.
//

import UIKit
import AFNetworking

enum FJNetworkToolsMethod: String {
    case get = "get"
    case post = "post"
}

class FJNetworking: AFHTTPSessionManager {
    // 全局访问点
    static let sharedTools: FJNetworking = {
        let tools = FJNetworking()
        // 反序列化格式
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
    }()
    
    /// 网络请求公共方法
    ///
    /// - parameter method:     请求方式
    /// - parameter urlString:   url 地址
    /// - parameter parameters: 请求参数
    /// - parameter success:    成功
    /// - parameter failure:    失败
    func requet(method: FJNetworkToolsMethod, urlString: String, parameters: Any?, success:@escaping (Any?)->(), failure:@escaping (Error)->()){
        // 如果是 get 请求
        if method == .get {
            get(urlString, parameters: parameters, progress: nil, success: { (_, responseObject) in
                success(responseObject)
                }, failure: { (_, error) in
                    failure(error)
            })
        }else {
            // post 请求
            post(urlString, parameters: parameters, progress: nil, success: { (_, responseObject) in
                success(responseObject)
                }, failure: { (_, error) in
                    failure(error)
            })
        }
        
    }
}

// MARK: - 首页相关接口
extension FJNetworking {
    func homeLoadData(sinceId: Int64, maxId: Int64, success:@escaping (Any?)->(), failure:@escaping (Error)->()){
        // 请求 url
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        // 请求参数
        let params: [String: Any] = [
            "access_token": FJUserAccountViewModel.sharedTools.accessToken!,
            "since_id":sinceId,
            "max_id":maxId
        ]
        // 发送请求
        requet(method: FJNetworkToolsMethod.get, urlString: urlString, parameters: params, success: success, failure: failure)
    }
}


// MARK: - OAuth 授权相关接口
extension FJNetworking {
    
    func oauthLoadUserAccount(code: String, success:@escaping (Any?)->(), failure:@escaping (Error)->()){
        
        //请求的 urlString
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        //请求参数
        let params = [
            
            "client_id":FJAppKey,
            "client_secret":FJAppSecret,
            "grant_type":"authorization_code",
            "code":code,
            "redirect_uri":FJRedirectUrl
        ]
        
        FJNetworking.sharedTools.requet(method: FJNetworkToolsMethod.post, urlString: urlString, parameters: params, success: success, failure: failure)
    }
    
    func oauthLoadUserInfo(model: FJUserAccountModel ,success:@escaping (Any?)->(), failure:@escaping (Error)->()) {
        
        let urlSting = "https://api.weibo.com/2/users/show.json"
        
        //请求参数
        let params = [
            "access_token":model.access_token!,
            "uid":model.uid!
        ]
        
        FJNetworking.sharedTools.requet(method: FJNetworkToolsMethod.get, urlString: urlSting, parameters: params, success: success, failure: failure)

    }
    
}

//发微博相关接口
extension FJNetworking {
    
    //  发图片微博
    //  发文字微博
    func upload(access_token: String, status: String, image: UIImage, success:@escaping (Any?)->(), failure:@escaping (Error)->()) {
        
        //  接口地址
        let url = "https://upload.api.weibo.com/2/statuses/upload.json"
        //  请求参数
        let params: [String: Any] = [
            "access_token": access_token,
            "status": status
        ]
        
        //  图片转成data
        //  0.5取值范围0-1图片的质量系数，系数越大，图片约清晰
        let data = UIImageJPEGRepresentation(image, 0.5)! //UIImagePNGRepresentation(image)!
        
        //  写到桌面
        //        (data as NSData).write(toFile: "/Users/Apple/Desktop/2.png", atomically: true)
  
        
        post(url, parameters: params, constructingBodyWith: { (formData) in
            //  data -> 图片二进制
            //  name -> 服务端所需要的参数，参数名称必须与指定的数据有关的名字。这个参数不能是nil。
            //  fileName -> 上次文件名，服务端一般不会用，自己会生成唯一的文件名
            //  mimeType -> 资源类型
            formData.appendPart(withFileData: data, name: "pic", fileName: "test", mimeType: "image/png")
            
            
            }, progress: nil, success: { (_, response) in
                success(response)
        }) { (_, error) in
            failure(error)
        }
        
        
    }

    
    //发送文字微博
    func update(access_token: String, status: String, success:@escaping (Any?)->(), failure:@escaping (Error)->()) {
        
        //请求接口地址
        let url = "https://api.weibo.com/2/statuses/update.json"
        //请求参数
        let params: [String: Any] = [
            "access_token" : access_token,
            "status": status
        ]
        
        //执行post网络请求
        requet(method: .post, urlString: url, parameters: params, success: success, failure: failure)
    }
    
}




