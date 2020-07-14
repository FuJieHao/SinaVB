//
//  HMStatusViewModel.swift
//  VVeibo21
//
//  Created by Apple on 18/10/26.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

/**
    - View 级别的 ViewModel
 
 */
class FJStatusViewModel: NSObject {
    // viewModel 管理HMStatusModel 对其数据进行处理
    var statusModel: FJStatusModel?{
        didSet{
            
            // 会员等级赋值
            mbrankImage = dealMbrankImage(mbrank: statusModel?.user?.mbrank ?? 0)
            // 微博认证赋值
            verifiedImage = dealVerifiedImage(verified: statusModel?.user?.verified ?? -1)
            
            // 转发微博拼接
            retweetContentText = "@\(statusModel?.retweeted_status?.user?.name ?? ""):\(statusModel?.retweeted_status?.text ?? "")"
            
            // 转发个数
            repostsCountStr = dealCount(count: statusModel?.reposts_count ?? 0, title: "转发")
            // 评论个数
            commentsCountStr = dealCount(count: statusModel?.comments_count ?? 0, title: "评论")
            // 赞个数
            attitudesStr = dealCount(count: statusModel?.attitudes_count ?? 0, title: "赞")
            //  处理来源数据
            handleSource(source: statusModel?.source ?? "")
            
            //处理微博数据转换成富文本
            originalAttributedStr = handleAttributedStr(text: statusModel?.text ?? "")
            //处理转发微博数据转成富文本
            retweetAttributedStr = handleAttributedStr(text: retweetContentText!)
        }
    }
    
    //原创微博的富文本
    var originalAttributedStr: NSAttributedString?
    
    //转发微博的富文本
    var retweetAttributedStr: NSAttributedString?
    
    // 会员等级 image
    var mbrankImage: UIImage?
    // 微博认证
    var verifiedImage: UIImage?
    // 转发微博显示的内容
    var retweetContentText: String?
    // 转发个数
    var repostsCountStr: String?
    // 评论个数
    var commentsCountStr: String?
    // 赞个数
    var attitudesStr: String?
    
    //  来源属性
    var sourceStr: String?
    //  时间格式化处理
    var timeStr: String? {
        //  把时间对象格式化成显示的时间字符串
        guard let createAt = statusModel?.created_at else {
            return nil
        }
        //  代码执行到此,表示时间对象不为 nil
        
        let dt = DateFormatter()
        //  指定本地化信息
        dt.locale = Locale(identifier: "en_US")
        
        if isThisYear(createAt: createAt) {
            //  判断是否是今天, 昨天,其它
            //  获取日历对象
            let calendar = Calendar.current
            if calendar.isDateInToday(createAt) {
                //  表示今天
                //  判断是否是1分钟之前,1小时之前,其它
                //                createAt.timeIntervalSince(Date())
                let timeInterval = abs(createAt.timeIntervalSinceNow)
                
                if timeInterval < 60 {
                    return "刚刚"
                } else if timeInterval < 3600 {
                    let result = Int(timeInterval) / 60
                    return "\(result)分钟前"
                } else {
                    let result = Int(timeInterval) / 3600
                    return "\(result)小时前"
                }
                
                
            } else if calendar.isDateInYesterday(createAt) {
                //  表示昨天
                dt.dateFormat = "昨天 HH:mm"
            } else {
                //  其它
                dt.dateFormat = "MM-dd HH:mm"
            }
            
            
        } else {
            // 不是今年
            dt.dateFormat = "yyyy-MM-dd HH:mm"
            
        }
        
        return dt.string(from: createAt)
    }
    
    //  根据发微博的时候判断是否是今年
    private func isThisYear(createAt: Date) -> Bool {
        
        let dt = DateFormatter()
        //  指定格式化方式
        dt.dateFormat = "yyyy"
        //  指定本地化信息
        dt.locale = Locale(identifier: "en_US")
        //  获取发微博的年份
        let creatAtYear = dt.string(from: createAt)
        
        //  获取当前时间的年份
        let currentDateYear = dt.string(from: Date())
        
        
        return creatAtYear == currentDateYear
        
    }

}

//处理 首页数据转成富文本逻辑
extension FJStatusViewModel {
    
    //根据微博内容生成富文本
    func handleAttributedStr(text: String) -> NSAttributedString {
        
        //根据文本内容创建富文本
        let resultAttributedStr = NSMutableAttributedString(string: text)
        
        //通过正则匹配微博内容中的表情描述字符串(可能报异常的方法)
        let matchResult = try! NSRegularExpression(pattern: "\\[\\w+\\]", options: []).matches(in: text, options: [], range: NSMakeRange(0, (text as NSString).length))
        
        //遍历匹配的东西(因为替换后我的内容会变短，如果继续正向遍历的话，到后面就会越界替换，为了防止这个情况的发生，所以我逆向遍历就好)
        for match in matchResult.reversed() {
            //获取匹配的范围
            let range = match.range
            //获取表情描述
            let chs = (text as NSString).substring(with: range)
            
            //根据表情描述查找表情模型
            if let emoticon = FJEmoticonTool.shareTool.selectEmoticonWithChs(chs: chs) {
                // 如果有，代表找到了
        
                let image = UIImage(named: emoticon.fullPath!)!
                
                let attributedStr = NSAttributedString.yy_attachmentString(withEmojiImage: image, fontSize: NormalFontSize)!
                
                resultAttributedStr.replaceCharacters(in: range, with: attributedStr)
                
            } else {
                print("表示没有找到")
            }
        }
        
//        //设置全部富文本的字体大小
        resultAttributedStr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: NormalFontSize), range: NSMakeRange(0, resultAttributedStr.length))
        
        //匹配 @ xxx:
        
        //根据富文本获取对应的字符串匹配对应的@ xx:
        
        addHighlightedAttributedString(pattern: "@[^:]+", resultAttributedStr: resultAttributedStr)
        //#xxx#
        addHighlightedAttributedString(pattern: "#[^#]+#", resultAttributedStr: resultAttributedStr)
        //http://xx
        addHighlightedAttributedString(pattern: "http[s]?://[^\\s\\u4e00-\\u9fa5]+", resultAttributedStr: resultAttributedStr)
        
        return resultAttributedStr
        
    }
    
    private func addHighlightedAttributedString(pattern: String, resultAttributedStr: NSMutableAttributedString) {
        
        let text = resultAttributedStr.string
        
        let matchHighlightedResult = try! NSRegularExpression(pattern: pattern, options: []).matches(in: text, options: [], range: NSMakeRange(0, (text as NSString).length))
        
        for matchHighlighted in matchHighlightedResult {
            //  匹配高亮文字的范围
            let highlightRange = matchHighlighted.range
            //  设置高亮范围的前景色
            let color = UIColor(red: 80 / 255, green: 125 / 255, blue: 215 / 255, alpha: 1)
            resultAttributedStr.addAttribute(NSForegroundColorAttributeName, value: color, range: highlightRange)
            
            
            let textHighlight = YYTextHighlight()
            //  高亮点击的高亮背景色
            let bgColor = UIColor(red: 177 / 255, green: 215 / 255, blue: 255 / 255, alpha: 1)
            let textBorder = YYTextBorder(fill: bgColor, cornerRadius: 3)
            //  设置边框内间距
            textBorder.insets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
            textHighlight.setBackgroundBorder(textBorder)
            //  设置富文本高亮效果
            resultAttributedStr.yy_setTextHighlight(textHighlight, range: highlightRange)
            
        }

        
    }
    
}

// 处理 转发 评论 赞 (业务逻辑)
extension FJStatusViewModel {
    /*
     - 处理 转发 评论 赞 (业务逻辑)
     
     - 如果 count <= 0 显示 转发 评论 赞
     - 如果 count > 0 && count < 10000  是多少显示多少 例如 7890 显示就是 7890
     - 如果 count >= 10000  显示 x.x 万    例如12000  显示 就是1.2万
     - 例如 20000  显示 2万   30000 显示 3万
     */
    // 处理转发 评论 赞 数
    func dealCount(count: Int, title: String) -> String{
        if count <= 0 {
            return title
        }else if count > 0 && count < 10000{
            return "\(count)"
        }else {
            let c = CGFloat(count/1000)/10
            var cStr = "\(c)万"
            
            // 如果cStr 包含.0
            if cStr.contains(".0") {
                // 字符串替换
                cStr = cStr.replacingOccurrences(of: ".0", with: "")
            }
            return cStr
        }
    }
}


extension FJStatusViewModel {
    
    //  处理来源数据
    func handleSource(source: String) {
        //  多可可选类型的判断
        if let startRange = source.range(of: "\">"), let endRange = source.range(of: "</") {
            
            //  获取开始光标位置索引
            //  upperBound表示范围的结束光标位置索引
            let startIndex = startRange.upperBound
            //  获取范围的开始光标位置索引
            let endIndex = endRange.lowerBound
            //  获取指定范围的字符串
            sourceStr = "来自:" + source.substring(with: startIndex..<endIndex)
            
        }
    }
    
    // 处理微博认证
    /// 认证类型 -1：没有认证，1，认证用户，2,3,5: 企业认证，220: 达人
    func dealVerifiedImage(verified: Int) -> UIImage?{
        switch verified {
        case 1:
            return UIImage(named: "avatar_vip")
        case 2,3,5:
            return UIImage(named: "avatar_enterprise_vip")
        case 220:
            return UIImage(named: "avatar_grassroot")
        default:
            return UIImage(named: " ")
        }
    }
    
    // 处理微博用户等级逻辑(1-6等级)
    func dealMbrankImage(mbrank: Int) -> UIImage?{
 
        if mbrank > 0 && mbrank < 7 {
            return UIImage(named: "common_icon_membership_level\(mbrank)")
        }else {
            return UIImage(named: "common_icon_membership")
        }
    }
}
