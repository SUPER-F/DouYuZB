//
//  NSDate-Extension.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/9/16.
//  Copyright © 2019 zpit. All rights reserved.
//

import Foundation

extension NSDate {
    static func getCurrentTime() -> String {
        let nowDate = NSDate()
        let interval = nowDate.timeIntervalSince1970
        
        return "\(interval)"
    }
}
