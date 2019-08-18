//
//  MainViewController.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/8/18.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildVc(storyName: "Home")
        addChildVc(storyName: "Live")
        addChildVc(storyName: "Follow")
        addChildVc(storyName: "Profile")
        
    }
    
    private func addChildVc(storyName: String) {
        let childVc = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        
        addChild(childVc)
    }

}
