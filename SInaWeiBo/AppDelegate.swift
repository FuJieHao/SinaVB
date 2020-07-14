//
//  AppDelegate.swift
//  SInaWeiBo
//
//  Created by Mac on 16/10/22.
//  Copyright © 2018年 haofujie. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.backgroundColor = UIColor.white
        
        // 01设置根控制器
        setupRootVc()
        // 成功主窗口 并显示
        window?.makeKeyAndVisible()
        // 注册通知切换跟控制器
        NotificationCenter.default.addObserver(self, selector: #selector(switchRootVc(noti:)), name: NSNotification.Name(rawValue: HMSWITCHROOTVCNOTI), object: nil)
        
        return true
    }
    
    // 设置根控制器
    func setupRootVc(){
        // 如果用户登录了 那么他的 rootVC = welcomeVc
        // 如果用户没有登录 那么他的 rootVc = hmmainvc
        if FJUserAccountViewModel.sharedTools.isLogin {
            window?.rootViewController = FJWelcomeViewController()
        }else {
            // 02
            window?.rootViewController = FJMainViewController()
        }
    }
    
    // 切换跟控制器
    func switchRootVc(noti: Notification){
        // 如果 noti.object == nil 就代表是从 OAuthVC发的通知 -> HMWelcomeVc
        // 如果 noti.object != nil 就代表是从 HMWelcomeVc 发的通知 -> HMMainVC
        
        if noti.object == nil {
            window?.rootViewController = FJWelcomeViewController()
        }else {
            window?.rootViewController = FJMainViewController()
        }
        
    }
    
    // 析构函数
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        FJStatusDAL.clearCacheData()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

