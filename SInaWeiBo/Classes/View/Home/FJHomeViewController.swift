//
//  HMHomeViewController.swift
//  VVeibo21
//
//  Created by Apple on 18/10/22.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

// cell 可重用表示符
private let statusCellIdentifier = "statusCellIdentifier"

class FJHomeViewController: FJBaseViewController {
    
    // viewModel 对象
    let statusListViewModel = FJStatusListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //我父类的一个属性，继承
        if !self.isLogin {
            
            self.visitorView?.setupVisitorViewInfo(imageName: nil, title: nil)
            return
        }
        setupUI()
        getStatusData()
    }

    //设置视图
    func setupUI() {
        setupNav()
        setupTableViewInfo()
        
        //  添加 tipLabel
        if let nav = self.navigationController {
            //  表示导航控制器存在
            nav.view.insertSubview(tipLabel, belowSubview: nav.navigationBar)
            //  获取最大 Y 轴
            tipLabel.frame = CGRect(x: 0, y: nav.navigationBar.frame.maxY - 35, width: nav.navigationBar.frame.width, height: 35)
        }
    }
    
    private func setupTableViewInfo() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(FJStatusTableViewCell.self, forCellReuseIdentifier: statusCellIdentifier)
        
        // cell 高度
        // UITableViewAutomaticDimension 自动计算行高
        tableView.rowHeight = UITableViewAutomaticDimension
        // 设置预估行高estimatedRowHeight -> 越接近真实高度越好
        tableView.estimatedRowHeight = 200
        
        //设置tableView 的显示样式
        tableView.separatorStyle = .none
        
        //footView
        tableView.tableFooterView = bottomView
        // 添加系统下拉刷新控件
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(getStatusData), for: UIControlEvents.valueChanged)
    }
    
    //设置导航
    private func setupNav() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(setImageName: "navigationbar_pop", target: self, action: #selector(leftClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(setImageName: "navigationbar_friendsearch", target: self, action: #selector(rightClick))
    }
    
    @objc private func leftClick() {
        
    }
    
    @objc private func rightClick() {
        
        let vc = FJTempViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - tipLabel 动画
    fileprivate func startTipAnimation(message: String) {
        
        if tipLabel.isHidden == false {
            //  表示正在执行动画
            return
        }
        
        tipLabel.isHidden = false
        tipLabel.text = message
        
        UIView.animate(withDuration: 1, animations: {
            self.tipLabel.transform = CGAffineTransform(translationX: 0, y: self.tipLabel.frame.height)
  
        }) { (_) in
            
            UIView.animate(withDuration: 1, animations: {
                self.tipLabel.transform = CGAffineTransform.identity
                }, completion: { (_) in
                    self.tipLabel.isHidden = true
            })
        }
    }
    
    // MARK: - 懒加载控件
    // 菊花残
    fileprivate lazy var bottomView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        // 设置颜色
        view.color = UIColor.purple
        return view
    }()
    
    fileprivate lazy var refreshControl: FJRefreshControl = FJRefreshControl()
    
    //  tipLabel
    fileprivate lazy var tipLabel: UILabel = {
        let label = UILabel(textColor: UIColor.white, fontSize: 11, text: "没有加载到最新微博数据")
        //  设置背景色和文字位置
        label.backgroundColor = UIColor.orange
        label.textAlignment = .center
        //  默认状态隐藏
        label.isHidden = true
        return label
        
    }()
}

extension FJHomeViewController {
    
    // 请求数据
    func getStatusData(){
        
        // bottomView.isAnimating 如果他开启动画 就代表是上啦加载更多 反之没有动画 我们就认为是下拉刷新
        // 委托 statusListViewModel 请求数据
        statusListViewModel.getHomeData(isPullUp: bottomView.isAnimating) { (isSuccess,message) in
            
            if !self.bottomView.isAnimating {
                self.startTipAnimation(message: message)
            }
            
            if !isSuccess {
                print("请求数据失败")
                
            }else {
                // 刷新 UI
                self.tableView.reloadData()
            }
            self.endRefreshing()
        }
    }
    
    // 停止下拉和上啦动画
    func endRefreshing() {
        // 停止动画
        self.bottomView.stopAnimating()
        // 下拉刷新也要停止
        self.refreshControl.endRefreshing()
    }}

extension FJHomeViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusListViewModel.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: statusCellIdentifier, for: indexPath) as! FJStatusTableViewCell
        
        // 给 cell 赋值
        cell.statusViewModel = statusListViewModel.dataArray[indexPath.row]
        
        //取消cell 的选中状态
        cell.selectionStyle = .none
        
        return cell
    }
    
    //将要显示的cell的代理
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // 如果 indexPath.row == 19  -> count - 1 代表显示最后一个 cell
        if indexPath.row == statusListViewModel.dataArray.count - 1 && !bottomView.isAnimating {
            // 开启动画
            bottomView.startAnimating()
            // 马上请求数据
            getStatusData()
        }
    }
}





