//
//  SqliteManager.swift
//  FMDB 
//
//  Created by Apple on 18/11/5.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
//  数据库路径
let DBPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString).appendingPathComponent("sinaWeibo.db")

//  封装 FMDB, 数据库的相关操作工具类
class SqliteManager: NSObject {

    //  单例的全局访问点
    static let sharedManager: SqliteManager = SqliteManager()
    //  数据库操作队列
    lazy var queue: FMDatabaseQueue = FMDatabaseQueue(path: DBPath)
    //  构造函数私有化
    private override init() {
        super.init()
  
        print(DBPath)
        createTables()
        
    }
    
    //  创建表
    private func createTables() {
        
        //  获取 db.sql 文件路径
        let path = Bundle.main.path(forResource: "db.sql", ofType: nil)!
        //  准备 sql 语句
        let sql = try! String(contentsOfFile: path)
        
        //  执行 sql 语句
        queue.inDatabase { (db) in
            let result = db?.executeStatements(sql)
            if result == true {
                print("创表成功")
            } else {
                print("创表失败")
            }
        }
    }
    
    //  插入
    func insert() {
        //  准备sql
        let sql = "INSERT INTO T_Person(NAME, AGE) VALUES(?, ?)"
        //  执行 sql
        queue.inDatabase { (db) in
            let result = db?.executeUpdate(sql, withArgumentsIn: ["杨钰莹", 18])
            if result == true {
                print("插入成功")
            } else {
                print("插入失败")
            }
            
        }
    
    }
    
    //  查询
    func select() {
        //  准备sql
        let sql = "SELECT ID, NAME, AGE FROM T_Person"
        
        //  执行 sql
        queue.inDatabase { (db) in
            if let resultSet = db?.executeQuery(sql, withArgumentsIn: nil) {
                //  遍历结果集
                while resultSet.next() {
                    //  根据列名获取对应的值
                    let id = resultSet.int(forColumn: "ID")
                    let name = resultSet.string(forColumn: "NAME")!
                    let age = resultSet.int(forColumn: "AGE")
                    print(id, name, age)
                
                }
                
            
            }
        }
    }
    
    //  查询2
    func selectDicArrayWithSql(sql: String) -> [[String: Any]] {
        
        var tempArray = [[String: Any]]()
        queue.inDatabase { (db) in
            if let resultSet = db?.executeQuery(sql, withArgumentsIn: nil) {
                while resultSet.next() {
                    //  每次遍历获取下一条记录 -> 每一条记录就是一个字典
                    var dic = [String: Any]()
                
                    //  获取列数
                    let count = resultSet.columnCount()
                    //  遍历列数获取列名和列值
                    for i in 0..<count {
                        //  根据列的索引获取列名
                        let colName = resultSet.columnName(for: i)!
                        //  根据列的索引获取列值
                        let colValue = resultSet.object(forColumnIndex: i)!
                        //  更新或者添加键值对
                        dic.updateValue(colValue, forKey: colName)
//                        dic[colName] = colValue
                    }
                    
                    //  把字典添加到数组里面
                    tempArray.append(dic)
                    
                }
            }
        }
        return tempArray
    
    }
    
    //  修改
    func update() {
        //  准备 sql 语句
        let sql = "UPDATE T_PERSON SET NAME = ?, AGE = ? WHERE ID = ?"
        //  执行 sql
        queue.inDatabase { (db) in
            let result = db?.executeUpdate(sql, withArgumentsIn: ["杨幂", 28, 2])
            if result == true {
                print("修改成功")
            } else {
                print("修改失败")
            }
        }
        
    }
    
    //  删除
    func delete() {
        //  准备 sql
        let sql = "DELETE FROM T_PERSON WHERE ID = ?"
        queue.inDatabase { (db) in
            let result = db?.executeUpdate(sql, withArgumentsIn: [1])
            if result == true {
                print("删除成功")
            } else {
                print("删除失败")
            }
        }
    
    }
    
    
    
    
}
