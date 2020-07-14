//
//  FJComposeViewController.swift
//  SInaWeiBo
//
//  Created by Mac on 18/11/1.
//  Copyright © 2018年 haofujie. All rights reserved.
//

import UIKit
import SVProgressHUD

class FJComposeViewController: UIViewController {
    
    // MARK: - 懒加载控件
    fileprivate lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        //  指定多行显示
        label.numberOfLines = 0
        //  判断是name 是否为 nil
        if let name = FJUserAccountViewModel.sharedTools.userAccountModel?.screen_name {
            let title = "发微博\n" + name
            //  创建富文本
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: title)
            //  获取 name 的 rang
            let range = (title as NSString).range(of: name)
            
            attributedString.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.brown], range: range)
            
            
            label.attributedText = attributedString

        } else {
            label.text = "发微博"
        }

        label.sizeToFit()
        
        return label
        
    }()
    
    //  发送按钮
    fileprivate lazy var sendButton: UIButton = {
        let button = UIButton()
        //  添加点击事件
        button.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        //  设置不同状态的背景图片
        button.setBackgroundImage(UIImage(named: "common_button_orange"), for: .normal)
        button.setBackgroundImage(UIImage(named: "common_button_orange_highlighted"), for: .highlighted)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: .disabled)
        //  设置文字及颜色
        button.setTitle("发送", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.gray, for: .disabled)
        //  设置字体大小
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        //  设置大小
        button.size = CGSize(width: 45, height: 35)
        
        return button
    }()
    
    //  textView ,输入框
    fileprivate lazy var textView: FJComposeTextView = {
        let composeTextView = FJComposeTextView()
        composeTextView.placeHolder = "请在此处输入博文（最多140字)"
        composeTextView.font = UIFont.systemFont(ofSize: 14)
        //  设置代理
        composeTextView.delegate = self
        //设置textView能够拖动
        composeTextView.alwaysBounceVertical = true
        return composeTextView
    }()
    
    //toolBar
    fileprivate lazy var toolBar: FJComposeToolBar = {
        let composeToolBar = FJComposeToolBar()
        return composeToolBar
    } ()
    
    //  添加撰写配图
    fileprivate lazy var pictureView: FJComposePictureView = {
        let view = FJComposePictureView()
        view.backgroundColor = self.view.backgroundColor
        return view
    }()
    
    // 表情键盘视图
    fileprivate lazy var emotionKeyboard: FJEmotionKeyBoard = {
        
        let keyboard = FJEmotionKeyBoard()
        
        //自定义表情键盘的大小
        keyboard.size = CGSize(width: self.textView.width, height: 216)
        
        return keyboard
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        setupUI()
    }
    
    private func setupUI() {
        
        //添加通知监听键盘frame的变化
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChange(noti:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        //监听表情按钮的点击
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectedEmoticonButtonNotiAction(noti:)), name: NSNotification.Name(DidSelectedEmoticonButtonNotification), object: nil)
        
        //监听删除表情按钮的点击
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectedDeleteEmoitconAction), name: NSNotification.Name(DidSelectedDeleteEmotionButtonNotification), object: nil)
        
        setupNav()
        
        view.addSubview(textView)
        textView.addSubview(pictureView)
        view.addSubview(toolBar)
        
        textView.snp_makeConstraints { (make) in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        toolBar.snp_makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(35)
        }
        
        pictureView.snp_makeConstraints { (make) in
            make.centerX.equalTo(textView)
            make.top.equalTo(textView).offset(100)
            make.width.equalTo(textView.snp_width).offset(-20)
            make.height.equalTo(textView.snp_width).offset(-20)
            
        }
        
        //  设置 toolbar 需要的闭包
        toolBar.callBack = { [weak self] (type: FJComposeToolBarButtonType) in
            switch type {
            case .picture:
                print("图片")
                self?.didSelectedPicture()
            case .mention:
                print("@")
            case .trend:
                print("#")
            case .emoticon:
                print("表情")
                self?.didSelectedEmotion()
            case .add:
                print("加号")
            }
        }
        //  设置配图的闭包
        pictureView.callBack = { [weak self] in
            self?.didSelectedPicture()
        }
    }
    
    //设置导航栏视图操作
    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", target:  self, action: #selector(cancelAction))
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        //  默认不可用
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    // MARK: - 监听表情按钮的点击
    @objc private func didSelectedEmoticonButtonNotiAction(noti: Notification) {
        //  获取对应的通知参数
        let emoticon = noti.object as! FJEmoticon
        
        textView.insertEmoticon(emoticon: emoticon)
        
        //保存点击的表情模型 -> 那么allEmoticonArray 数据源发生了变化，需要重新加载数据
        FJEmoticonTool.shareTool.saveRecentEmoticon(emoticon: emoticon)
        
        //刷新最近这组表情数据
        emotionKeyboard.reloadRecentData()
    }
    
    // MARK: - 监听删除表情按钮点击的方法
    @objc private func didSelectedDeleteEmoitconAction() {
        //  删除操作
        textView.deleteBackward()
    }
    
    @objc private func cancelAction() {
        
        //textView.resignFirstResponder()
        self.view.endEditing(true)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - 点击导航栏按钮操作
    
    @objc private func sendAction() {
        
        //  获取 token
        let accessToken = FJUserAccountViewModel.sharedTools.accessToken!
        //  获取微博内容
        let text = textView.emoticonText
        
        SVProgressHUD.show()
        if pictureView.images.count > 0  {
            let image = pictureView.images.first!
            FJNetworking.sharedTools.upload(access_token: accessToken, status: text, image: image, success: { (response) in
                SVProgressHUD.showSuccess(withStatus: "发布成功")
                }, failure: { (error) in
                    print(error)
                    SVProgressHUD.showError(withStatus: "发布失败")
            })
            
            
        } else {
            FJNetworking.sharedTools.update(access_token: accessToken, status: text, success: { (response) in
                SVProgressHUD.showSuccess(withStatus: "发布成功")
                
                
            }) { (error) in
                print(error)
                SVProgressHUD.showError(withStatus: "发布失败")
            }
        }

    }
    
    // MARK: - 监听键盘 frame 的改变
    @objc private func keyboardFrameChange(noti: Notification) {
        //  获取键盘的 frame
        let keybardFrame = (noti.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        //  动画时长
        let duration = (noti.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        //  更新 toolbar 底部约束
        toolBar.snp_updateConstraints { (make) in
            make.bottom.equalTo(view).offset(keybardFrame.origin.y - ScreenHeight)
        }
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

//点击toolBar的相关逻辑处理
extension FJComposeViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    /*
     这里的逻辑是：当属性的inputView为nil的时候，就会展示系统的
     那么当为nil的时候，我设置成自定义
     当不是Nil的时候，那就是正在显示自定义，我再次点击把它变成nil，那么系统的就出来了
     */

    //点击表情按钮的处理
    func didSelectedEmotion() {
        if textView.inputView == nil {
            
            //设置自定义输入视图
            textView.inputView = emotionKeyboard
            toolBar.showIcon(isEmotion: true)
        } else {
            //设置为系统键盘
            textView.inputView = nil
            toolBar.showIcon(isEmotion: false)
        }
        
        //如果在键盘上进行添加驶入
//        textView.inputAccessoryView
        
        //让textView成为第一响应者（对inputView)进行操作的时候
        textView.becomeFirstResponder()
        //还要刷新自定义输入视图，否则会有问题(你可以调用这个方法，使视图正常显示)
        textView.reloadInputViews()
    }

    //点击图片的处理逻辑
    func didSelectedPicture() {
        //  创建图片浏览器对象
        let imagePickerCtr = UIImagePickerController()
        //  设置代理对象
        imagePickerCtr.delegate = self
        //  判断是否支持相机
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //  支持相机
            imagePickerCtr.sourceType = .camera
        } else {
            //  支持相册
            imagePickerCtr.sourceType = .photoLibrary
        }
        //  判断是否支持前置摄像头或者后置摄像头
        if UIImagePickerController.isCameraDeviceAvailable(.front) {
            //  表示支持前置摄像头
            print("支持前置摄像头")
        }
        
        if UIImagePickerController.isCameraDeviceAvailable(.rear) {
            //  表示支持后置摄像头
            print("支持后置摄像头")
        }
        
        if UIImagePickerController.isCameraDeviceAvailable(.front) == false && UIImagePickerController.isCameraDeviceAvailable(.rear) == false {
            print("摄像头不可用")
        }
        //  表示允许编辑 -> 如果开启了编辑,那么可以获取编辑或的这个图片UIImagePickerControllerEditImage
        //        imagePickerCtr.allowsEditing = true
        
        
        self.present(imagePickerCtr, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //  添加显示的图片
        pictureView.addImage(image: image)
        //  如果实现了代理方法, 那么自己去 dismis 图片浏览器
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("你点击取消按钮")
        //  如果实现了代理方法, 那么自己去 dismis 图片浏览器
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func scaleImage(scaleWidth: CGFloat, image: UIImage) -> UIImage {
        
        //  宽度 100, 高度 200,  压缩后的宽度 50, 计算压缩后的高度
        //  计算压缩后的高度
        let scaleHeight = scaleWidth / image.size.width * image.size.height
        //  压缩后的大小
        let scaleSize = CGSize(width: scaleWidth, height: scaleHeight)
        //  开启图片上下文
        UIGraphicsBeginImageContext(scaleSize)
        //  把图片渲染到指定的区域内
        image.draw(in: CGRect(origin: CGPoint.zero, size: scaleSize))
        //  通过图片上下文获取当前的图片
        let currentScaleImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //  关闭图片上下文
        UIGraphicsEndImageContext()
        return currentScaleImage!
    }
}

extension FJComposeViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        //判断textView是否有内容，如果有内容那么按钮可用，否则不可用
         navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //让键盘失去第一响应者
        self.view.endEditing(true)
    }
}
