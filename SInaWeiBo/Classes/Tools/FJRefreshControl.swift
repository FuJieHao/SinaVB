//
//  FJRefreshControl.swift
//  VVeibo21
//
//  Created by Apple on 18/10/30.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

//  自定义下拉刷新的状态
private enum HMRefreshType: Int {
    //  下拉刷新状态
    case normal = 0
    //  松手就刷新
    case pulling = 1
    //  正在刷新
    case refreshing = 2
}


//  自定义控件的高度
private let FJRefreshControlHeight: CGFloat = 50

//  自定义下拉刷新控件
class FJRefreshControl: UIControl {

    //  记录当前刷新的控件
    private var currentScrollView: UIScrollView?
    //  记录当前刷新状态
    private var hmRefreshType: HMRefreshType = .normal {
        didSet {
            switch hmRefreshType {
            case .normal:
                print("下拉刷新")
                //  箭头重置, 箭头显示, 关闭风火轮, 内容改成下拉刷新
                pullDownImageView.isHidden = false
                UIView.animate(withDuration: 0.25, animations: {
                    //  重置箭头位置
                    self.pullDownImageView.transform = CGAffineTransform.identity
                })
                indicatorView.stopAnimating()
                messageLabel.text = "下拉刷新"
                
                //  判断上一次刷新状态是正在属性,让重置默认位置
                //  oldValue 表示上一次存储的值
                if oldValue == .refreshing {
                    UIView.animate(withDuration: 0.25, animations: {
                        //  设置停留位置, 核心代码 , 重置停留位置
                        self.currentScrollView?.contentInset.top -= FJRefreshControlHeight
                    })
                }
               
                
                
            case .pulling:
                print("松手就刷新")
                //  箭头调转, 内容修改成松手就刷新
                UIView.animate(withDuration: 0.25, animations: {
                    //  调转箭头位置
                    self.pullDownImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                })
                messageLabel.text = "松手就刷新"
                
                
            case .refreshing:
                print("正在刷新")
                //  箭头隐藏, 开启风火轮, 内容改成正在刷新
                pullDownImageView.isHidden = true
                //  开启风火轮
                indicatorView.startAnimating()
                messageLabel.text = "正在刷新..."
                
                UIView.animate(withDuration: 0.25, animations: { 
                    //  设置停留位置, 核心代码
                    self.currentScrollView?.contentInset.top += FJRefreshControlHeight
                })
                
                //  通知外界刷新数据 (核心代码)
                sendActions(for: .valueChanged)
                
                
                
                
                
            }
        }
    }
    
    // MARK: - 懒加载控件
    //  下拉箭头图片
    fileprivate lazy var pullDownImageView: UIImageView = UIImageView(image: UIImage(named: "tableview_pull_refresh"))
    //  下拉刷新内容 label
    fileprivate lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "下拉刷新"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.gray
        return label
    
    }()
    //  风火轮
    fileprivate lazy var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //  获取屏幕的宽度
        let screenWidth = UIScreen.main.bounds.size.width
        //  设置 frame
        self.frame = CGRect(x: 0, y: -FJRefreshControlHeight, width: screenWidth, height: FJRefreshControlHeight)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  添加控件设置约束
    private func setupUI() {
        backgroundColor = UIColor.white
        //  添加子控件设置约束
        addSubview(pullDownImageView)
        addSubview(messageLabel)
        addSubview(indicatorView)
        
        
        //  使用系统布局 autolayout 需要关闭 Autoresizing
        pullDownImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        //  添加约束
        addConstraint(NSLayoutConstraint(item: pullDownImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: -35))
        addConstraint(NSLayoutConstraint(item: pullDownImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .leading, relatedBy: .equal, toItem: pullDownImageView, attribute: .trailing, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .centerY, relatedBy: .equal, toItem: pullDownImageView, attribute: .centerY, multiplier: 1, constant: 0))

        addConstraint(NSLayoutConstraint(item: indicatorView, attribute: .centerX, relatedBy: .equal, toItem: pullDownImageView, attribute: .centerX, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: indicatorView, attribute: .centerY, relatedBy: .equal, toItem: pullDownImageView, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    //  获取父控件, 当前控件将要添加到那个父视图上面
    override func willMove(toSuperview newSuperview: UIView?) {
        print(newSuperview)
        //  判断是否是可以滚动的控件
        if let scrollView = newSuperview as? UIScrollView {
            //  表示是 UIScrollView 的子类, 可以监听器滚动
            //  可以使用 kvo 监听 contentOffSet 值得改变
            
            //  [.new, .old] 表示可以监听新值和旧值得改变
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
            //  记录刷新视图控件
            currentScrollView = scrollView
            
        }
    }
    
    //  kvo监听方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let scrollView = currentScrollView else {
            return
        }
        
        //  代码执行到此,表示 scrollView 不为 nil
        
        //  计算临界点
        let maxY = -(scrollView.contentInset.top + FJRefreshControlHeight)
        //  获取 y 轴偏移量
        let contentOffSetY = scrollView.contentOffset.y
        
       
        //  判断是否拖动
        //  拖动情况下只有两种状态 .normal, pulling
        if scrollView.isDragging {
            //  表示在拖动 判断的核心
            if contentOffSetY < maxY && hmRefreshType == .normal  {
                hmRefreshType = .pulling
                print("pulling")
            } else if contentOffSetY >= maxY && hmRefreshType == .pulling {
                hmRefreshType = .normal
                print("normal")
            }

        } else {
            //  表示松手 , 只有 pulling 状态 才能进入正在刷新
            
            if hmRefreshType == .pulling {
                hmRefreshType = .refreshing
                print("正在刷新")
            }
        }
    }
    
    //  结束刷新
    func endRefreshing() {
        hmRefreshType = .normal
    }
    
    deinit {
        //  移除 kvo
        currentScrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    

}
