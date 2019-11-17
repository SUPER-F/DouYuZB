//
//  CycleModel.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/11/16.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit

class CycleModel: NSObject {
    // 标题
    @objc var title: String = ""
    // 展示的轮播图片
    @objc var pic_url: String = ""
    // 主播信息对应的字典
    @objc var room: [String : NSObject]? {
        didSet {
            guard let room = room else { return }
            anchor = AnchorModel(dict: room)
        }
    }
    // 主播信息对应的模型对象
    @objc var anchor: AnchorModel?
    
    // 自定义构造函数
    init(dict: [String : NSObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    // 一定要重写x此方法，否则很可能崩溃
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
