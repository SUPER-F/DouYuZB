//
//  CollectionHeaderView.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/8/27.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var groupImgv: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var group: AnchorGroup? {
        didSet {
            groupImgv.image = UIImage.init(named: group?.icon_name ?? "")
            titleLabel.text = group?.tag_name
        }
    }
    
}
