//
//  CollectionPrettyCell.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/8/28.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit

class CollectionPrettyCell: CollectionBaseCell {
    
    @IBOutlet weak var placeBtn: UIButton!
    
    override var anchor: AnchorModel? {
        didSet {
            super.anchor = anchor
            
            placeBtn.setTitle(anchor?.anchor_city, for: .normal)
            
        }
    }

}
