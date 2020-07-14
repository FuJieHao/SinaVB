//
//  HMStatusPictrueView.swift
//  VVeibo21
//
//  Created by Apple on 18/10/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import SDWebImage

// cell 可重用标识符
private let pictureViewCellIdentifier = "pictureViewCellIdentifier"
// cell 间距
private let cellMargin: CGFloat = 5
// cell 宽高
private let cellWH = CGFloat(Int((ScreenWidth - 20 - cellMargin*2)/3))

class FJStatusPictrueView: UICollectionView {

    // 定义属性 -> 数组
    var picUrls:[FJPictureInfoModel]?{
        didSet{
            // 赋值
//            countLabel.text = "\(picUrls?.count ?? 0)"
            
            
//            // 得到配图大小
//            let size = dealScaleSize(count: picUrls?.count ?? 0)
//            // 设置约束 -> 更新
//            self.snp_updateConstraints { (make) in
//                make.size.equalTo(size)
//            }
            
            dealScaleSize(count: picUrls?.count ?? 0)
            
            // 刷新 UI
            reloadData()
        }
    }
    
    
    // 计算配图 size
    func dealScaleSize(count: Int){
        
        // 如果是单张图片
        if count == 1 {
            
            // 获取 key
            let key = picUrls?.first?.thumbnail_pic ?? ""
            
            // 获取 image 从缓存中获取 image
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: key.replacingOccurrences(of: "thumbnail", with: "bmiddle"))
            
            // 因为SDWebImage 下载图片可能因为外界影响导致图图片下载不成功 所以说 防止 image == nil  我们需要做判断
            if image != nil {
                let result = image!.size
                
                // 更新约束
                self.snp_updateConstraints(closure: { (make) in
                    make.size.equalTo(result)
                })
                layoutIfNeeded()
                // 设置 itemSize
                let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
                layout.itemSize = result
                
                return
            }
        }
        
        // 行数和列数
        let col = count >= 3 ? 3 : count
        let row = (count - 1)/3 + 1
        
        // 最终宽和高
        let w = CGFloat(col) * cellWH + CGFloat(col - 1)*cellMargin
        let h = CGFloat(row) * cellWH + CGFloat(row - 1)*cellMargin
        
        // 更新约束
        self.snp_updateConstraints(closure: { (make) in
            make.size.equalTo(CGSize(width: w, height: h))
        })
        layoutIfNeeded()
        
        // 设置 itemSize
        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWH, height: cellWH)
        layout.minimumLineSpacing = cellMargin
        layout.minimumInteritemSpacing = cellMargin
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 设置视图
    private func setupUI(){
        
//        backgroundColor = UIColor.groupTableViewBackground
//        // 得到 layout
//        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        // 设置 itemSize
//        layout.itemSize = CGSize(width: cellWH, height: cellWH)
        // 设置间距
//        layout.minimumLineSpacing = cellMargin
//        layout.minimumInteritemSpacing = cellMargin
        // 设置代理
        dataSource = self
        // 注册 cell
        register(FJStatusPictrueViewCell.self, forCellWithReuseIdentifier: pictureViewCellIdentifier)
//        // 添加控件
//        addSubview(countLabel)
        // 添加约束
//        countLabel.snp_makeConstraints { (make) in
//            make.center.equalTo(self)
//        }

    }
    
    // MARK: - 懒加载控件
//    private lazy var countLabel: UILabel = {
//        let lab = UILabel(textColor: UIColor.red, fontSize: 35, text: "")
//        lab.textAlignment = .center
//        return lab
//    }()
    
}

//MARK: - UICollectionViewDataSource
extension FJStatusPictrueView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pictureViewCellIdentifier, for: indexPath) as! FJStatusPictrueViewCell
        // 赋值
        cell.picUrl = picUrls![indexPath.item]
        return cell
    }
}

// 自定义 配图cell
class FJStatusPictrueViewCell: UICollectionViewCell {
    
    // 定义数据供外界调用
    var picUrl: FJPictureInfoModel?{
        didSet{
            
            bgImageView.sd_setImage(with: URL(string: (picUrl?.thumbnail_pic?.replacingOccurrences(of: "thumbnail", with: "bmiddle") ?? "")), placeholderImage:UIImage(named:"timeline_image_placeholder") )
            
            if picUrl?.thumbnail_pic?.hasSuffix(".gif") == true {
                //如果是gif图片让其显示
                gifImageView.isHidden = false
                
            } else {
                //隐藏gif图片
                gifImageView.isHidden = true
            }
       
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 设置视图
    private func setupUI(){
        backgroundColor = UIColor.groupTableViewBackground
        // 添加控件
        contentView.addSubview(bgImageView)
        contentView.addSubview(gifImageView)
        
        // 添加约束
        bgImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        gifImageView.snp_makeConstraints { (make) in
            make.bottom.equalTo(bgImageView)
            make.trailing.equalTo(bgImageView)
        }
    }
    
    // MARK: - 懒加载控件
    private lazy var bgImageView:UIImageView = {
        let view = UIImageView(imageName: "timeline_image_placeholder")
        // 图片显示样式
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        return view
    }()
    
    //GIF 图片
    private lazy var gifImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
        return imageView
    } ()
}

