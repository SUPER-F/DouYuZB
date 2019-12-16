//
//  CustomNavController.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/11/21.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit

class CustomNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.获取系统的pop手势
        guard let systemGes = interactivePopGestureRecognizer else { return }
        
        // 2.获取系统手势添加的view
        guard let gesView = systemGes.view else { return }
        
        // 3.获取target/action
        // 3.1.利用runtime查看所有属性名称
        /*
        var count: UInt32 = 0
        let ivars = class_copyIvarList(UIGestureRecognizer.self, &count)!
        for i in 0..<count {
            let ivar = ivars[Int(i)]
            let name = ivar_getName(ivar)
            print(String(cString: name!))
        }
        */
        let targets = systemGes.value(forKey: "_targets") as? [NSObject]
        guard let targetObjc = targets?.first else { return }
        
        // 3.2.取出target
        guard let target = targetObjc.value(forKey: "target") else { return }
        
        // 3.3.取出action
        let action = Selector(("handleNavigationTransition:"))
        
        // 4.创建自己的Pan手势
        let panGes = UIPanGestureRecognizer()
        
        // 5.给创建的Pan手势添加target/action
        panGes.addTarget(target, action: action)
        
        // 6.把创建的Pan手势添加在系统手势添加的view上
        gesView.addGestureRecognizer(panGes)
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 隐藏要push的控制器的TabBar
        viewController.hidesBottomBarWhenPushed = true
        
        super.pushViewController(viewController, animated: animated)
    }
    
}
