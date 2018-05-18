//
//  AppDelegate.swift
//  知乎日报
//
//  Created by 邹凯章 on 17/3/8.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let tableView = UITableView.appearance()
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        let scrollView = UIScrollView.appearance()
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        self.window = UIWindow(frame: UIScreen.main.bounds)
        // Override point for customization after application launch.
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let menuStoryboard = UIStoryboard(name: "Menu", bundle: nil)
        
        let mainReactor = MainViewReactor()
        
        let mainViewController = mainStoryboard.instantiateInitialViewController() as! MainViewController
        mainViewController.reactor = mainReactor
        
        let serviceProvider = ServiceProvider()
        let menuReactor = MenuViewReactor(provider: serviceProvider)
        let MenuViewController = menuStoryboard.instantiateInitialViewController() as! MenuViewController
        MenuViewController.reactor = menuReactor
        
        // 设置slideMenuController
        SlideMenuOptions.hideStatusBar = true
        SlideMenuOptions.leftViewWidth = 225
        SlideMenuOptions.contentViewScale = 1.0
        // 创建slideMenuController
        let slideMenuController = SlideMenuController(mainViewController: mainViewController, leftMenuViewController: MenuViewController)
        
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
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

