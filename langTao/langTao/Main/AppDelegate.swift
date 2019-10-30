//
//  AppDelegate.swift
//  langTao
//
//  Created by LonTe on 2019/7/26.
//  Copyright © 2019 LonTe. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let manager = NetworkReachabilityManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        sleep(2)
                
        UINavigationBar.appearance().barTintColor = LTTheme.navBG
        UINavigationBar.appearance().tintColor = LTTheme.navTitle
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont.boldSystemFont(ofSize: 20), .foregroundColor : LTTheme.navTitle]
        
        UITabBar.appearance().barTintColor = LTTheme.navBG
        UITabBar.appearance().tintColor = LTTheme.select
        UITabBar.appearance().isTranslucent = false
        
        UITextField.appearance().tintColor = LTTheme.select
        UITableView.appearance().tintColor = LTTheme.select
        UITextView.appearance().tintColor = LTTheme.select

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done".localString
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        
        let homeNav = LTNavigationController(rootViewController: LTHomeViewController())
        let classNav = LTNavigationController(rootViewController: LTClassViewController())
//        let massageNav = LTNavigationController(rootViewController: LTMassageViewController())
//        let newsNav = LTNavigationController(rootViewController: LTNewsViewController())
        let mineNav = LTNavigationController(rootViewController: LTMineViewController())
//        let tabBar = LTTabBarController(withViewControllers: [homeNav, classNav, massageNav, newsNav, mineNav])
        let tabBar = LTTabBarController(withViewControllers: [homeNav, classNav, mineNav])

        manager?.listener = {
            switch $0 {
            case .unknown:
                LTHUD.show(text: "Unknown network".localString)
            case .notReachable:
                LTHUD.show(type: .error, text: "Network anomalies".localString)
            case .reachable(.ethernetOrWiFi):
                LTHUD.show(text: "Using WiFi".localString)
            case .reachable(.wwan):
                LTHUD.show(text: "Using 3G/4G".localString)
            }
        }
        
        manager?.startListening()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
        
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

