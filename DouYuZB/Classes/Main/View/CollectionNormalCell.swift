//
//  CollectionNormalCell.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/8/27.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit

class CollectionNormalCell: CollectionBaseCell {
    // 控件属性
    @IBOutlet weak var roomNameLabel: UILabel!
    
    override var anchor: AnchorModel? {
        didSet {
            super.anchor = anchor
            
            roomNameLabel.text = anchor?.room_name
            
        }
    }

}
