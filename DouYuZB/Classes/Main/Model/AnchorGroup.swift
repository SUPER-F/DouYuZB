//
//  AnchorGroup.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/9/17.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit

class AnchorGroup: NSObject {
    // 该组中对应的房间信息
    @objc var room_list: [[String : NSObject]]? {
        didSet {
            guard let room = room_list else { return }
            for dict in room {
                anchors.append(AnchorModel(dict: dict))
            }
        }
    }
    // 组显示的标题
    @objc var tag_name: String = ""
    // 组显示的图标
    @objc var icon_name: String = "home_header_normal"
    
    // 定义主播的模型对象数组
    @objc lazy var anchors: [AnchorModel] = [AnchorModel]()
    
    override init() {
        super.init()
    }
    
    init(dict: [String : NSObject]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    /*
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "room_list" {
            if let dataArray = value as? [[String : NSObject]] {
                for dict in dataArray {
                    anchors.append(AnchorModel(dict: dict))
                }
            }
        }
    }
    */
}
