//
//  HMStatusListViewModel.swift
//  VVeibo21
//
//  Created by Apple on 18/10/26.
//  Copyright © 2018年 Apple. All rights reserved.
//
/*
    - 帮助首页请求数据 提供数据
    - 首页需要知道 ViewModel 请求数据成功 或者失败
        - 如果成功 -> HomeVC 刷新 UI
        - 如果失败 -> 告知用户加载数据失败
 */
import UIKit
import SDWebImage

class FJStatusListViewModel: NSObject {
    
    // 保存微博数据数组
    var dataArray:[FJStatusViewModel] = [FJStatusViewModel]()

    // 请求首页数据
    func getHomeData(isPullUp:Bool, finish:@escaping (Bool, String)->()){
        
        // isPullUp  = true 代表是上啦加载更多
        // isPullUp  = false 代表是 下拉刷新
        
        
        var maxId: Int64 = 0
        var sinceId: Int64 = 0
        // 如果是上啦加载更多
        if isPullUp {
            maxId = dataArray.last?.statusModel?.id ?? 0
            //则返回ID小于或等于max_id的微博，默认为0。
            if maxId > 0 {
                maxId -= 1
            }
            sinceId = 0
        }else {
            sinceId = dataArray.first?.statusModel?.id ?? 0
            maxId = 0
        }
        
        var message = "没有加载到最新微博数据"
        
        //  检查本地是否有缓存数据
        let localArray = FJStatusDAL.checkCacheData(maxId: maxId, sinceId: sinceId)
        
        if localArray.count > 0 {
            
            print("我找到本地数据了")
            
            // yymodel使用直接转出数组
            let statusArray = NSArray.yy_modelArray(with: FJStatusModel.self, json: localArray) as! [FJStatusModel]
            
            // 创建一个临时可变的数组
            var tempArray:[FJStatusViewModel] = [FJStatusViewModel]()
            
            // 遍历statusArray
            for model in statusArray {
                let statusViewModel = FJStatusViewModel()
                // 给其身上的 model 赋值
                statusViewModel.statusModel = model
                // 添加 viewmodel 到数组中
                tempArray.append(statusViewModel)
            }
            // 保存数据
            // 如果是上啦加载更多
            if isPullUp {
                self.dataArray = self.dataArray + tempArray
            }else {
                // 下拉刷新
                self.dataArray = tempArray + self.dataArray
            }
            
            if tempArray.count > 0 {
                message = "加载了\(tempArray.count)条微博数据"
            }
            //  回调数据
            finish(true, message)
            
            return

        }
        

        FJNetworking.sharedTools.homeLoadData(sinceId: sinceId, maxId: maxId, success: { (response) in
            
            //            print("请求成功",response)
            // 判断response 是否为 nil 而且是否转成字典
            guard let resDict = response as? [String: Any] else {
                print("可能为 nil 可能转不出字典")
                finish(false,message)
                return
            }
            // 判断resDict["statuses"] 是否为 nil 而且是否可以转成数组
            guard let resArr = resDict["statuses"] as? [[String: Any]] else {
                print("可能为 nil 可能转不出数组")
                finish(false,message)
                return
            }
            
            //缓存新浪微博数据
            FJStatusDAL.cacheData(statusDicArray: resArr)
            
            // yymodel使用直接转出数组
            let statusArray = NSArray.yy_modelArray(with: FJStatusModel.self, json: resArr) as! [FJStatusModel]
            
            // 创建一个临时可变的数组
            var tempArray:[FJStatusViewModel] = [FJStatusViewModel]()
            
            // 遍历statusArray
            for model in statusArray {
                let statusViewModel = FJStatusViewModel()
                // 给其身上的 model 赋值
                statusViewModel.statusModel = model
                // 添加 viewmodel 到数组中
                tempArray.append(statusViewModel)
            }
            
            // 保存数据
            // 如果是上啦加载更多
            if isPullUp {
                self.dataArray = self.dataArray + tempArray
            }else {
                // 下拉刷新
                self.dataArray = tempArray + self.dataArray
            }
            
            self.loadSingeImage(array: tempArray, finish: finish)
           
            
            }) { (error) in
                print("请求失败", error)
                finish(false,message)
        }
    }
}

extension FJStatusListViewModel{
    // 单张图片下载
    func loadSingeImage(array: [FJStatusViewModel], finish:@escaping (Bool, String)->()){
        
        // 创建调度组
        let group = DispatchGroup()
        
        // 遍历数组
        for statusViewModel in array {
            
            // 如果是原创微博 && count == 1
            
            if statusViewModel.statusModel?.pic_urls?.count == 1 {
                let url = URL(string: statusViewModel.statusModel?.pic_urls?.first?.thumbnail_pic ?? "")!
                group.enter()
                SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, error, _, _, _) in
                    
                    print("原创微博图片下载完成")
                    group.leave()
                })
                
            }
            
            // 如果是转发微博 && count == 1
            if statusViewModel.statusModel?.retweeted_status?.pic_urls?.count == 1 {
                let url = URL(string: statusViewModel.statusModel?.retweeted_status?.pic_urls?.first?.thumbnail_pic ?? "")!
                group.enter()
                SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, error, _, _, _) in
                    
                    print("转发微博图片下载完成")
                    group.leave()
                })
            }
        }
        
        // 调度组统一监听单张图片是否全部下载完成
        group.notify(queue: .main) {
            print("所有图片全部下载完成")
            var message = "没有加载到最新微博数据"
            if array.count > 0 {
                message = "加载了\(array.count)条微博数据"
            }
            // 代表成功
            finish(true, message)
        }
    }
}

