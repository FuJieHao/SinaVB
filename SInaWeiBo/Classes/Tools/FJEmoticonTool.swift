//
//  FJEmoticonTool.swift
//  SInaWeiBo
//
//  Created by Mac on 18/11/2.
//  Copyright © 2018年 haofujie. All rights reserved.
//

import UIKit

//每页上有20个表情
let NumberOfPage = 20

//归档和解档路径
let RecentEmoticonPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString).appendingPathComponent("recentEmoticonArray.archive")

//这里要把bundle数据的处理和业务逻辑处理分离开
//做成单例（为什么？方便调用，设置成不可以改动）
class FJEmoticonTool: NSObject {
    
    //单例全局访问点
    static let shareTool: FJEmoticonTool = FJEmoticonTool()
    
    //构造函数的私有化，这样外界就不能调用init方法，修改内部了
    private override init() {
        super.init()
        
    }
    
    //创建emoticon bundel 对象
    lazy var emoticonsBundle: Bundle = {
       
        //突然想知道Bundle 是个什么东西
        //获取表情bundle 文件的路径
        let path = Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil)!
        
        //根据路径创建Bundle对象
        let bundle = Bundle(path: path)!
        
        return bundle
    }()
    
    //获取默认表情
    private lazy var defaultEmoticonArray: [FJEmoticon] = {
       
        return self.loadEmoticonArray(folderName:"default",fileName:"info.plist")
    }()
    
    //获取emoji表情
    private lazy var emojiEmoticonArray: [FJEmoticon] = {
        
        return self.loadEmoticonArray(folderName:"emoji", fileName:"info.plist")
    }()
    
    //获取浪小花表情
    private lazy var lxhEmoticonArray: [FJEmoticon] = {
       
        return self.loadEmoticonArray(folderName:"lxh", fileName:"info.plist")
    }()
    
    //最近表情(这个暂时不做，玩个空的就好）
    private lazy var recentEmoticonArray: [FJEmoticon] = {
       
        if let localArray = self.loadRecentEmoticon() {
            
            //表示有最近表情数据
            return localArray
            
        } else {
        
            let emoticonArray = [FJEmoticon]()
            return emoticonArray
        }
    }()
    
    //准备表情视图所需要的数据(这里就存成三维数组，一会玩起来6）
    lazy var allEmoticonArray: [[[FJEmoticon]]] = {
        
        return [
        
            //最近表情这组数据
            [self.recentEmoticonArray],
            //默认表情这组数据
            self.sectionEmoticonsArray(emoticons: self.defaultEmoticonArray),
            //默认emoji这组数据
            self.sectionEmoticonsArray(emoticons: self.emojiEmoticonArray),
            //默认浪小花这组数据
            self.sectionEmoticonsArray(emoticons: self.lxhEmoticonArray)
        
        ]
        
    }()
    
    //根据Bundle+文件夹名+文件名获取对应的表情数据
    //返回一个模型数组
    private func loadEmoticonArray(folderName: String, fileName: String) -> [FJEmoticon] {
        
        //子路径拼接
        let subPath = folderName + "/" + fileName
        
        //当使用上面的Bundle找资源的时候，会透过两层文件夹(Contents/Resources)
        let path = self.emoticonsBundle.path(forResource: subPath, ofType: nil)
        
        //加载plist文件数据 -> 返回数组字典
        let dictArray = NSArray(contentsOfFile: path!)!
        
        //通过YYModel 把字典数组 转换成 模型数组
        let modelArray = NSArray.yy_modelArray(with: FJEmoticon.self, json: dictArray) as! [FJEmoticon]
        
        
        //顺道遍历一下表情模型判断是否是图片表情（emoji是字符，不是图片)
        for model in modelArray {
            
            if model.type == "0" {
                
                //表示图片的话，需要拼接路径
                                //根路径
                let path = self.emoticonsBundle.path(forResource: folderName, ofType: nil)! + "/" + model.png!
                //得到图片的全路径（为什么需要图片的全路径，因为你在这里导入的Bundle包，他本身是有路径的(MainBundle包有个bundle包），所以要有图片的路径）
                model.fullPath = path
                //保存图片对应的文件夹
                model.folderName = folderName
            }
        }
        
        return modelArray
    }
    
    //把表情数据(一个模型数组)拆分成二维数组
    private func sectionEmoticonsArray(emoticons: [FJEmoticon]) -> [[FJEmoticon]] {
        
        // 根据传入表情数组的个数计算显示的页数
        let pageCount = (emoticons.count - 1) / NumberOfPage + 1
        //创建二维数组
        var tempArray = [[FJEmoticon]]()
        
        //遍历页数，获取对应表情数据
        for i in 0..<pageCount {
            
            //开始截取索引
            let loc = i * NumberOfPage
            var len = NumberOfPage
            
            if loc + len > emoticons.count {
                //超出范围的话，截取剩余的个数
                len = emoticons.count - loc
            }
            
            //如果超出范围的话，那么要在子数组里存东西，会数组越界，所以要做判断
            let subArray = (emoticons as NSArray).subarray(with: NSRange(location: loc, length: len)) as! [FJEmoticon]
            
            tempArray.append(subArray)
        }
        
        return tempArray
    }
    
    //读取本地最近的表情数据
    func loadRecentEmoticon() -> [FJEmoticon]? {
        
        //完成解档
        let array = NSKeyedUnarchiver.unarchiveObject(withFile: RecentEmoticonPath) as? [FJEmoticon]
        
        return array
    }
    
    //添加最近表情数据
    func saveRecentEmoticon(emoticon: FJEmoticon) {
        
        //判断最近表情里面是否存在传入的表情模型
        for (i,etn) in recentEmoticonArray.enumerated() {
            
            //如果是图片，判断 chs
            if etn.type == "0" {
                
                if emoticon.chs == etn.chs {
                    //删除表情
                    recentEmoticonArray.remove(at: i)
                    break
                }
            } else {
                //不是图片判断code 
                if emoticon.code == etn.code {
                    recentEmoticonArray.remove(at: i)
                    
                    break
                }
            }
        }
        
        //插入到第一个元素的位置
        recentEmoticonArray.insert(emoticon, at: 0)
        
        //当超出20个表情后把最后一个表情元素删除
        while recentEmoticonArray.count > 20 {
            //删除最后一个
            recentEmoticonArray.removeLast()
        }
        
        //修改数据源
        allEmoticonArray[0][0] = recentEmoticonArray
        
        //归档最近表情
        NSKeyedArchiver.archiveRootObject(recentEmoticonArray, toFile: RecentEmoticonPath)
    }
    
    //根据表情描述查找表情模型
    func selectEmoticonWithChs(chs: String) -> FJEmoticon? {
        
        //只找默认表情和浪小花表情就可以了
        for emoticon in defaultEmoticonArray {
            if emoticon.chs == chs {
                //这就代表找到了对应的表情模型
                return emoticon
            }
        }
        
        for emoticon in lxhEmoticonArray {
            if emoticon.chs == chs {
                //找到了浪小花的模型
                return emoticon
            }
        }
        
        //否则的话，代表没有找到对应的表情模型
        return nil
    }
}






