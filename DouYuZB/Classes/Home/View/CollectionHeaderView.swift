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
    @IBOutlet weak var moreBtn: UIButton!
    
    var group: AnchorGroup? {
        didSet {
            groupImgv.image = UIImage.init(named: group?.icon_name ?? "")
            titleLabel.text = group?.tag_name
        }
    }
    
}

extension CollectionHeaderView {
    class func collectionHeaderView() -> CollectionHeaderView {
        return Bundle.main.loadNibNamed("CollectionHeaderView", owner: nil, options: nil)?.first as! CollectionHeaderView
    }
}
