//
//  HMStatusDAL.swift
//  VVeibo21
//
//  Created by Apple on 18/11/5.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

//  删除缓存时间
let MaxTimeinterval: Double = 10 * 60

//  数据库访问层, 用于缓存和查询新浪微博数据
class FJStatusDAL: NSObject {
    
    //  检查本地缓存数据
    class func checkCacheData(maxId: Int64, sinceId: Int64) -> [[String: Any]] {
        //SELECT * FROM statuses where statusid < 4038506742820291 and userid = 5898275120 order by statusid desc limit 20
        //  拼接 sql 语句
        var sql = "SELECT * FROM statuses\n"
        if maxId > 0 {
            //  表示上拉加载
            sql += "where statusid < \(maxId)\n"
        } else {
            //  表示下拉刷新
            sql += "where statusid > \(sinceId)\n"
        }
        //  获取登录用户的 id
        let userid = FJUserAccountViewModel.sharedTools.userAccountModel?.uid
        //  拼接用户 id
        sql += "and userid = \(userid!)\n"
        
        //  拼接排序方式和最大返回条数
        sql += "order by statusid desc limit 20\n"
        
        //  执行查询 sql 语句
        /*  [
         ["statusid": 1, status: xx, userid: xx, time: xxx],
         ["statusid": 1, status: xx, userid: xx, time: xxx]
         ]
         */
        
        let localArray = SqliteManager.sharedManager.selectDicArrayWithSql(sql: sql)
        //  存储遍历的每一天微博字典数据让首页显示
        var tempArray = [[String: Any]]()
        //  遍历本地缓存数据,获取对应的微博内容
        for localDic in localArray {
            //  获取微博内容二进制数据
            let statusData = localDic["status"] as! Data
            
            //   把数据反序列化字典
            let statusDic = try! JSONSerialization.jsonObject(with: statusData, options: []) as! [String: Any]
            tempArray.append(statusDic)
        }
        
        return tempArray
    }
    
    
    //  缓存新浪微博数据
    class func cacheData(statusDicArray: [[String : Any]]) {
        //"statusid" INTEGER PRIMARY KEY  NOT NULL ,"status" TEXT NOT NULL ,"userid"
        //  准备 sql
        let sql = "INSERT INTO Statuses(statusid, status, userid) VALUES(?, ?, ?)"
        
        //  获取用户 id
        let userid = FJUserAccountViewModel.sharedTools.userAccountModel?.uid
        //  rollBack 表示是否数据回滚的标记
        SqliteManager.sharedManager.queue.inTransaction { (db, rollBack) in
            
            for statusDic in statusDicArray {
                //  微博 id
                let statusid = statusDic["id"]!
                //  把字典序列化二进制数据
                let statusData = try! JSONSerialization.data(withJSONObject: statusDic, options: [])
                //  执行 sql
                let result = db?.executeUpdate(sql, withArgumentsIn: [statusid, statusData, userid!])
                
                if result == false {
                    //  数据回滚
                    rollBack?.pointee = true
                    break
                }
            }
        }
    }
    
    //  清除缓存数据
    class func clearCacheData() {
        let date = Date().addingTimeInterval(-MaxTimeinterval)
        
        let dt = DateFormatter()
        dt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dt.locale = Locale(identifier: "en_US")
        //  时间对象转成字符串
        let maxTimeStr = dt.string(from: date)
        //  准备 sql
        let sql = "delete from statuses where time < '\(maxTimeStr)'"
        
        //  执行 sql
        SqliteManager.sharedManager.queue.inDatabase { (db) in
            //  执行 sql
            let result = db?.executeUpdate(sql, withArgumentsIn: nil)
            
            if result == true {
                //  db!.changes() 表示这次操作影响的条数
                print("缓存数据删除成功,影响了\(db!.changes())")
            } else {
                print("缓存数据删除失败")
            }
        }
        
    }
    
}
