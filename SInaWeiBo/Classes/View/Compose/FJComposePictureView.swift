//
//  HMComposePictureView.swift
//  VVeibo21
//
//  Created by Apple on 18/11/1.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
//  重用标记
private let FJComposePictureViewCellIdentifier = "FJComposePictureViewCellIdentifier"

//  撰写配图视图
class FJComposePictureView: UICollectionView {
    
    //  执行打开图片浏览器的闭包
    var callBack: (()->())?

    //  图片显示的数据源
    lazy var images: [UIImage] = [UIImage]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        super.init(frame: frame, collectionViewLayout: flowLayout)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
//        backgroundColor = UIColor.red
        
        //  注册 cell
        register(FJComposePictureViewCell.self, forCellWithReuseIdentifier: FJComposePictureViewCellIdentifier)
        
        //  设置数据源代理
        dataSource = self
        delegate = self
    }
    
    //  添加选中的图片
    func addImage(image: UIImage) {
        if images.count >= 9 {
            return
        }
        
        //  添加图片的时候显示当前视图
        isHidden = false
        images.append(image)
        //  数据源发生改变重新加载数据
        reloadData()
        
    }
    
    // 计算每项条目的大小
    override func layoutSubviews() {
        super.layoutSubviews()
        //  每项的间距
        let itemMargin: CGFloat = 5
        //  每项的宽度
        let itemWidth = (width - 2 * itemMargin) / 3
        
        let flowLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        //  设置条目大小
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        //  设置水平间距
        flowLayout.minimumInteritemSpacing = itemMargin
        //  设置垂直间距
        flowLayout.minimumLineSpacing = itemMargin

    }
}

extension FJComposePictureView: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.images.count == 0 || self.images.count == 9 {
            return self.images.count
        } else {
            return self.images.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FJComposePictureViewCellIdentifier, for:  indexPath) as! FJComposePictureViewCell
        
        //  设置选中的图片
        if indexPath.item == self.images.count {
            cell.image = nil
        } else {
            //  显示图片
            cell.image = self.images[indexPath.item]
            cell.callBack = { [weak self] (index: Int) in
                //  根据图片的索引删除指定元素
                self?.images.remove(at: index)
                //  如果图片删除后个数是0 隐藏当前视图
                if self?.images.count == 0 {
                    self?.isHidden = true
                }
                
                self?.reloadData()
            }
        }
        cell.indexPath = indexPath
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == self.images.count {
            //  打开图片浏览器
            callBack?()
        }
        
    }

}


//  自定义配图 cell
class FJComposePictureViewCell: UICollectionViewCell {
    
    //  设置当前的 indexPath
    var indexPath: IndexPath?
    //  需要执行点击删除按钮的闭包
    var callBack: ((Int)->())?
    
    // MARK: - 懒加载控件
    private lazy var imageView: UIImageView = UIImageView(image: UIImage(named: "timeline_image_placeholder"))
    //  删除按钮
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        //  添加点击事件
        button.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        button.setImage(UIImage(named: "compose_photo_close"), for: .normal)
        return button
        
        
    }()

    
    var image: UIImage? {
        didSet {
            if image == nil {
                //  需要设置加号图片显示
                imageView.image = UIImage(named: "compose_pic_add")
                //  把删除按钮隐藏
                deleteButton.isHidden = true
            } else {
                imageView.image = image
                deleteButton.isHidden = false
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
    
    //  添加子控件设置约束
    private func setupUI() {
        
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        
        imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        deleteButton.snp_makeConstraints { (make) in
            make.top.equalTo(imageView)
            make.trailing.equalTo(imageView)
        }
    }
    
    // MARK: - 点击删除按钮操作
    @objc private func deleteButtonAction() {
        
        if let idp = indexPath {
            
            //  执行删除图片的闭包
            callBack?(idp.item)
        }
    }

}











