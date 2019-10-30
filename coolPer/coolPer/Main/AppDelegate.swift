//
//  AppDelegate.swift
//  coolPer
//
//  Created by LangTe on 2019/7/5.
//  Copyright © 2019 LangTe. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let manager = NetworkReachabilityManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().tintColor = LTTheme.navTitle
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = LTTheme.navBG
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : LTTheme.navTitle, .font : UIFont.boldSystemFont(ofSize: 20)]

        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "完成"
        IQKeyboardManager.shared.enable = true
        UITextField.appearance().tintColor = LTTheme.navBG
        
        manager?.listener = {
            switch $0 {
            case .unknown:
                LTHUD.show(text: "未知网络")
            case .notReachable:
                LTHUD.show(type: .error, text: "网络异常")
            case .reachable(.ethernetOrWiFi):
                LTHUD.show(text: "正在使用WiFi")
            case .reachable(.wwan):
                LTHUD.show(text: "正在使用3G/4G")
            }
        }
        manager?.startListening()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = LTNavigationController(rootViewController: LTHomeViewController())
        window?.makeKeyAndVisible()
        sleep(2)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

