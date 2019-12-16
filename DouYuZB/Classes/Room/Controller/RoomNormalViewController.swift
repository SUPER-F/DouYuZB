//
//  RoomNormalViewController.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/11/21.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit

class RoomNormalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.randomColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 隐藏导航栏
        navigationController?.setNavigationBarHidden(true, animated: true)
        /* 因为CustomNavController中替换了Pan手势，所有这里不用保持了
        // 保持可以侧滑返回
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 显示导航栏
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
