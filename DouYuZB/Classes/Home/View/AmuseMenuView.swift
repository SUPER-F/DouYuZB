//
//  AmuseMenuView.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/11/19.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit

private let kMenuCellID = "kMenuCellID"

class AmuseMenuView: UIView {
    
    var groups: [AnchorGroup]? {
        didSet {
            collectionView.reloadData()
        }
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "AmuseMenuViewCell", bundle: nil), forCellWithReuseIdentifier: kMenuCellID)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
    }
}

extension AmuseMenuView {
    class func amuseMenuView() -> AmuseMenuView {
        return Bundle.main.loadNibNamed("AmuseMenuView", owner: nil, options: nil)?.first as! AmuseMenuView
    }
}

// 遵守 UICollectionView 的数据源协议
extension AmuseMenuView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if groups == nil { return 0 }
        let pageNum = (groups!.count - 1) / 8 + 1
        pageControl.numberOfPages = pageNum
        
        return pageNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kMenuCellID, for: indexPath) as! AmuseMenuViewCell
        
        setupCellDataWithCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    private func setupCellDataWithCell(cell: AmuseMenuViewCell, indexPath: IndexPath) {
        // 0页：0 ~ 7
        // 1页：8 ~ 15
        // 2页：16 ~ 23
        // 1.取出起始位置&终点位置
        let startIndex = indexPath.item * 8
        var endIndex = (indexPath.item + 1) * 8 - 1
        
        // 2.判断越界问题
        if endIndex > groups!.count - 1 {
            endIndex = groups!.count - 1
        }
        
        cell.groups = Array(groups![startIndex...endIndex])
    }
}

// 遵守 UICollectionView 的代理协议
extension AmuseMenuView : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1.获取滚动的偏移量
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width / 2.0
        
        // 2.计算pageControl的currentIndex
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width)
    }
}
