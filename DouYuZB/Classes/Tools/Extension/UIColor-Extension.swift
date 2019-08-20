//
//  UIColor-Extension.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/8/19.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
}
