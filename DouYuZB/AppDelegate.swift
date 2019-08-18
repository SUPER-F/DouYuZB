//
//  AppDelegate.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/8/18.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UITabBar.appearance().tintColor = UIColor.orange
        
        return true
    }
    
}

