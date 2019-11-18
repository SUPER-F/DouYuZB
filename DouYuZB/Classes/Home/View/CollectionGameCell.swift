//
//  CollectionGameCell.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/11/16.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionGameCell: UICollectionViewCell {

    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // 数据模型
    var baseGame: BaseGameModel? {
        didSet {
            titleLabel.text = baseGame?.tag_name
            
            let iconUrl = URL(string: baseGame?.icon_url ?? "")
            iconImgView.kf.setImage(with: iconUrl, placeholder: UIImage(named: "home_more_btn"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
