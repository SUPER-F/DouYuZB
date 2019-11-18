//
//  BaseGameModel.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/11/17.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit

class BaseGameModel: NSObject {
    // 标题
    @objc var tag_name: String = ""
    // 图片
    @objc var icon_url: String = ""
    
    override init() {
        super.init()
    }
    
    // 自定义构造函数
    init(dict: [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
