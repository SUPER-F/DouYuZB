//
//  CollectionCycleCell.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/11/16.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionCycleCell: UICollectionViewCell {

    @IBOutlet weak var ImgView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // 定义模型属性
    var cycleModel: CycleModel? {
        didSet {
            guard let cycleModel = cycleModel else {
                return
            }
            titleLabel.text = cycleModel.title
            
            guard let iconUrl = URL(string: cycleModel.pic_url) else {
                return
            }
            ImgView.kf.setImage(with: iconUrl)
        }
    }

}
