//
//  FJOAuthViewController.swift
//  SInaWeiBo
//
//  Created by Mac on 18/10/23.
//  Copyright © 2018年 haofujie. All rights reserved.
//

import UIKit
import YYModel
import SVProgressHUD
class FJOAuthViewController: UIViewController {
    
    //我让初始页就是网页
    override func loadView() {
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupNav()
    }

    private lazy var webView: UIWebView = {
        
        let url = URL(string: "https://api.weibo.com/oauth2/authorize?client_id=\(FJAppKey)&redirect_uri=\(FJRedirectUrl)")!
        
        let request = URLRequest(url: url)
        
        let webView = UIWebView()
        webView.delegate = self
        webView.loadRequest(request)
       
        
        return webView;
        
    }()
    
    
    private func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(setImageName: nil, title: "取消", target: self, action: #selector(back))
        navigationItem.rightBarButtonItem = UIBarButtonItem(setImageName: nil, title: "自动填充", target: self, action: #selector(autoClick))
        navigationItem.title = "微博登录"
    }
    
    @objc private func back() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func autoClick() {
        // jsString
        let jsString = "document.getElementById('userId').value='\(FJWeiBoName)',document.getElementById('passwd').value='\(FJWeiBoPassword)'"
        // js注入
        webView.stringByEvaluatingJavaScript(from: jsString)
    }
}

extension FJOAuthViewController: UIWebViewDelegate {
    
    //通过监听webView 的 request， 来得到code 码 默认不实现，返回的是true
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        //绝对路径
        let urlString = request.url?.absoluteString

        //判断urlString 不为 nil 而且前缀包含我们的回调页
        if let u = urlString, u.hasPrefix(FJRedirectUrl) {
            //请求参数 query 就是GET请求问号后面的东西
            let query = request.url?.query
            
            //判断请求的参数是否为nil
            if let q = query {
                
                //在参数里面截取到code码
                let code = q.substring(from: "code=".endIndex)
   
                FJUserAccountViewModel.sharedTools.getUserAccount(code: code, finish: { (isTrue) in
                    if !isTrue {
                        
                        SVProgressHUD.showError(withStatus: "请求失败")
                        
                        return
                    }
                    
                    
                    SVProgressHUD.dismiss()
                    self.dismiss(animated: false, completion: {
                        // 发通知跳转到欢迎界面03
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: HMSWITCHROOTVCNOTI), object: nil)
                        
                    })
                })
                // 不在叫他加载授权界面
                return false
            }
        }
        
        return true
    }
    
    // 将要加载 webview
    func webViewDidStartLoad(_ webView: UIWebView) {
        // 开始动画
        SVProgressHUD.show()
    }
    // 加载完成
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // 结束动画
        SVProgressHUD.dismiss()
    }
    // 加载失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
}





















