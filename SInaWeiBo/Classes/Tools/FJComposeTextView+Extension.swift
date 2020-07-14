//
//  FJComposeTextView+Extension.swift
//  SInaWeiBo
//
//  Created by Mac on 16/11/5.
//  Copyright © 2016年 haofujie. All rights reserved.
//

import UIKit

extension FJComposeTextView {
    
    var emoticonText: String {
        
        var result = ""
        
        //遍历富文本
        self.attributedText.enumerateAttributes(in: NSMakeRange(0, self.attributedText.length), options: []) { (info, range, _) in
            
            //二逼参数的含义
            /*
             info:富文本的描述信息
             range:富文本的范围
             unsafeMutablePointer: 遍历是否停止标记
             */
            
            if let attachment = info["NSAttachment"] as? FJTextAttachment {
                //表示是蹄片表情富文本
                let emoticon = attachment.emoticon!
                
                result += emoticon.chs!
            } else {
                
                //文字
                let textAttributedStr = self.attributedText.attributedSubstring(from: range)
                
                //根据富文本火球对应的字符串
                let text = textAttributedStr.string
                result += text
            }
        }
        
        return result
    }
    
    //  根据表情模型插入对应的富文本
    func insertEmoticon(emoticon: FJEmoticon){
        
        if emoticon.type == "0" {
            
            //记录上一次的富文本
            let lastAttributedString = NSMutableAttributedString(attributedString: self.attributedText)
            
            //根据图片的全路径创建 UIImage 对象
            let image = UIImage(named: emoticon.fullPath!)
            //根据UIImage对象创建文本附件(NSTextAttachment)
            let attachment = FJTextAttachment()
            //给文本附件设置显示的图片
            attachment.image = image
            //设置成为文字大小
            let fontHeight = self.font!.lineHeight
            //设置表情模型
            attachment.emoticon = emoticon
            //文本附件bounds大小
            attachment.bounds = CGRect(x: 0, y: -4, width: fontHeight, height: fontHeight)
            //根据文本附件创建富文本(NSAttributedString)
            let attributedStr = NSAttributedString(attachment: attachment)
            
            //拼接富文本(这个为了防止你进行替换，所以是拼接，那么的话，你就需要记录之前的东西)
//            lastAttributedString.append(attributedStr)
            
            //  获取选中的富文本
            var selectRange = self.selectedRange
            lastAttributedString.replaceCharacters(in: selectRange, with: attributedStr)
            
            //设置富文本的字体大小
            lastAttributedString.addAttribute(NSFontAttributeName, value: self.font!, range: NSMakeRange(0, lastAttributedString.length))
            
            //设置富文本
            self.attributedText = lastAttributedString
            
            //  设置光标位置
            selectRange.location += 1
            //  设置范围的长度
            selectRange.length = 0
            self.selectedRange = selectRange
            
            //  设置富文本不会发送文字改变的通知和不调用文字改变的代理方法,所以自己玩
            
            //自己发送文字改变的通知
            NotificationCenter.default.post(name: NSNotification.Name.UITextViewTextDidChange, object: nil)
            
            //  自定义使用代理对象调用代理方法
            //  文字改变的代理方法是可选, 为了安全性,可以使用?判断一下这个方式是否实现,如果实现了那么可以直接调用,否则直接 nil
            //类似于自己写的代理 response 是否响应
            self.delegate?.textViewDidChange?(self)
            
        } else {
            //  emoji
            self.insertText((emoticon.code! as NSString).emoji())
        }
        
    }
}
