//
//  CollectionBaseCell.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/9/20.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionBaseCell: UICollectionViewCell {
    // 控件属性
    @IBOutlet weak var onlineBtn: UIButton!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var bgImgv: UIImageView!
    
    var anchor: AnchorModel? {
        didSet {
            guard let anchor = anchor else { return }
            
            var onlineStr = ""
            if anchor.online >= 10000 {
                onlineStr = "\(anchor.online / 10000)万在线"
            } else {
                onlineStr = "\(anchor.online)在线"
            }
            onlineBtn.setTitle(onlineStr, for: .normal)
            
            nickNameLabel.text = anchor.nickname
            
            guard let iconUrl = NSURL(string: anchor.vertical_src) else {
                return
            }
            bgImgv.kf.setImage(with: ImageResource(downloadURL: iconUrl as URL))
        }
    }
}
