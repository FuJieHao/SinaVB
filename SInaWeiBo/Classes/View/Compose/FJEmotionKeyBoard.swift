//
//  FJEmotionKeyBoard.swift
//  SInaWeiBo
//
//  Created by Mac on 18/11/2.
//  Copyright © 2018年 haofujie. All rights reserved.
//

import UIKit

//  重用标记
private let FJEmoticonCollectionViewCellIdentifier = "FJEmoticonCollectionViewCellIdentifier"

class FJEmotionKeyBoard: UIView {

 /*
     1.表情视图 -> UICollectionView
     2.页数指示器 -> UIPageControl
     3.toolBar -> UIStackView
     
     */
    
    //懒加载控件
    
    //toolBar
    fileprivate lazy var toolBar: FJEmoticonToolBar = FJEmoticonToolBar()
    //表情视图
    fileprivate lazy var emoticonCollectionView: UICollectionView = {
       
        let flowLayout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.backgroundColor = self.backgroundColor
        //设置分页
        view.isPagingEnabled = true
        //设置水平滚动
        flowLayout.scrollDirection = .horizontal
        //取消弹簧效果
        view.bounces = false
        //隐藏滚动指示器
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        
        //  注册 cell
        view.register(FJEmoticonCollectionViewCell.self, forCellWithReuseIdentifier: FJEmoticonCollectionViewCellIdentifier)
        //  设置数据源代理
        view.dataSource = self
        view.delegate = self
        
        return view
    }()
    
    //页数指示器
    fileprivate lazy var pageControl: UIPageControl = {
        
        let ctr = UIPageControl()
        //只有单页的时候不显示
        ctr.hidesForSinglePage = true
        
        ctr.numberOfPages = 3
        ctr.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named: "compose_keyboard_dot_selected")!)
        ctr.pageIndicatorTintColor = UIColor(patternImage: UIImage(named:"compose_keyboard_dot_normal")!)
        
        return ctr
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        //  默认滚动的 indexPath
        let normalIndexPath = IndexPath(item: 0, section: 1)
        //  等待其他视图加载完成并且绑定完数据以后才会执行滚动操作
        DispatchQueue.main.async {
            self.emoticonCollectionView.scrollToItem(at: normalIndexPath, at: .left, animated: false)
        }
        
        backgroundColor = UIColor(patternImage: UIImage(named: "emoticon_keyboard_background")!)
        addSubview(emoticonCollectionView)
        addSubview(toolBar)
        addSubview(pageControl)
        
        emoticonCollectionView.snp_makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(toolBar.snp_top)
        }
        
        pageControl.snp_makeConstraints { (make) in
            make.bottom.equalTo(emoticonCollectionView)
            make.centerX.equalTo(emoticonCollectionView)
            make.height.equalTo(10)
        }
        
        toolBar.snp_makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(35)
        }
        
        toolBar.callBack = { [weak self] (type:FJEmoticonToolBarButtonType) in
            
            let indexPath: IndexPath
            switch type {
            case .recent:
                //  滚动到最近表情
                print("滚动到最近表情")
                indexPath = IndexPath(item: 0, section: 0)
            case .normal:
                //  滚动到默认表情
                print("滚动到默认表情")
                indexPath = IndexPath(item: 0, section: 1)
            case .emoji:
                //  滚动到emoji 表情
                print("滚动到emoji 表情")
                indexPath = IndexPath(item: 0, section: 2)
            case .lxh:
                //  滚动到浪小花表情
                print("滚动到浪小花表情")
                indexPath = IndexPath(item: 0, section: 3)
            }
            //  不需要开启动画
            self?.emoticonCollectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            self?.setPageControlData(indexPath: indexPath)
        }
        
    }
    
    //根据对应的indexPath ，设置UIPageControl 的 数据
    fileprivate func setPageControlData(indexPath: IndexPath) {
        //统计指定section里cell的个数
        pageControl.numberOfPages = FJEmoticonTool.shareTool.allEmoticonArray[indexPath.section].count
        pageControl.currentPage = indexPath.item
    }
    
    //加载最近表情这组数据
    func reloadRecentData() {
        let indexPath = IndexPath(item: 0, section: 0)
        //重新刷新加载最近表情这组数据
        emoticonCollectionView.reloadItems(at: [indexPath])
    }
    
    //设置表情视图item的大小
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let flowLayout = emoticonCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        //设置item的大小
        flowLayout.itemSize = emoticonCollectionView.size
        
        //设置水平和垂直碱韭
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
    }
}

//数据源方法
extension FJEmotionKeyBoard: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return FJEmoticonTool.shareTool.allEmoticonArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FJEmoticonTool.shareTool.allEmoticonArray[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FJEmoticonCollectionViewCellIdentifier, for: indexPath) as! FJEmoticonCollectionViewCell
        
        //获取表情数组元素
        cell.emoticonArray = FJEmoticonTool.shareTool.allEmoticonArray[indexPath.section][indexPath.item]
        
        return cell
    }
    
    //监听collectionView的滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //  获取collectionView 的内容的中心点
        let currentCenterX = scrollView.contentOffset.x + emoticonCollectionView.width * 0.5
        let currentCenterY = scrollView.contentOffset.y + emoticonCollectionView.height * 0.5
        //  中心点
        let currentCenter = CGPoint(x: currentCenterX, y: currentCenterY)
        if let indexPath = emoticonCollectionView.indexPathForItem(at: currentCenter) {
            let section = indexPath.section
            
            
            //  根据指定的 section 让 toolbar 选中对应的表情数据按钮
            toolBar.selectedButtonWithSection(section: section)
            setPageControlData(indexPath: indexPath)
        }
    }
}






