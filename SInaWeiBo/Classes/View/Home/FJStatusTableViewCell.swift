//
//  FJStatusTableViewCell.swift
//  SInaWeiBo
//
//  Created by Mac on 18/10/31.
//  Copyright © 2018年 haofujie. All rights reserved.
//

import UIKit

class FJStatusTableViewCell: UITableViewCell {
    
    // 底部视图顶部约束记录
    var bottomViewTopCons: Constraint?
    
    // 定义一个属性HMStatusViewModel
    var statusViewModel: FJStatusViewModel?{
        didSet{
            // 给原创微博赋值
            originalView.statusViewModel = statusViewModel
            /*
             - 通过retweeted_status 打印 发现 他可能为 nil 可能有值
             
             
             - 卸载约束
             
             - nil 就代表没有转发微博
             - 不需要赋值 -> 你赋值也都是 nil
             - bottomView.top = originalView.bottome
             - 反之 就代表有转发微博
             - 给转发微博赋值
             - bottomView.top = retweetView.bottome
             
             
             - 当我们使用 cell 是复用的 会导致你本来没有转发微博 但是可以看到转发微博的影子
             - 只要创建出来的 cell  转发 和原创 还有底部视图 但是有时候你根本不需要显示转发微博
             - 解决方案:
             - 如果你不需要显示转发微博  那么就隐藏他
             - 如果你需要显示转发微博 那么久显示他
             
             */
            
            // 卸载约束
            bottomViewTopCons?.uninstall()
            //没有转发微博
            if statusViewModel?.statusModel?.retweeted_status == nil {
                bottomView.snp_updateConstraints(closure: { (make) in
                    self.bottomViewTopCons = make.top.equalTo(originalView.snp_bottom).constraint
                })
                
                // 隐藏
                retweetView.isHidden = true
                
            }else {
                
                // 切记先赋值
                retweetView.statusViewModel = statusViewModel
                
                // 有转发微博
                bottomView.snp_updateConstraints(closure: { (make) in
                    self.bottomViewTopCons = make.top.equalTo(retweetView.snp_bottom).constraint
                })
                // 显示
                retweetView.isHidden = false
            }

            // 底部视图赋值
            bottomView.statusViewModel = statusViewModel
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 设置视图
    private func setupUI(){
//        backgroundColor = RandColor()
        // 01- 添加控件
        contentView.addSubview(originalView)
        contentView.addSubview(retweetView)
        contentView.addSubview(bottomView)
        // 02- 添加约束
        originalView.snp_makeConstraints { (make) in
            make.top.equalTo(contentView).offset(8)
            make.left.right.equalTo(contentView)
            //            make.leading.right.top.equalTo(contentView)
            // 此约束已经放到原创微博中
//            make.height.equalTo(50)
        }
        
        retweetView.snp_makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(originalView.snp_bottom)
            // 该约束已经放到了转发微博中
            //            make.height.equalTo(50)
        }
        
        bottomView.snp_makeConstraints { (make) in
            self.bottomViewTopCons = make.top.equalTo(retweetView.snp_bottom).constraint
            make.left.right.equalTo(contentView)
            make.height.equalTo(35)
            make.bottom.equalTo(contentView)
        }
        
    }
    
    // MARK: - 懒加载控件
    // 原创微博
    private lazy var originalView: FJStatusOriginalView = FJStatusOriginalView()
    // 转发微博
    private lazy var retweetView: FJStatusRetweetView = FJStatusRetweetView()
    // 底部视图
    private lazy var bottomView: FJStatusBottomView = FJStatusBottomView()

}
