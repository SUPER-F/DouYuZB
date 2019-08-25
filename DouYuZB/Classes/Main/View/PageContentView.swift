//
//  PageContentView.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/8/19.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}

let kContentCellID = "kContentCellID"

class PageContentView : UIView {
    // 定义属性
    private var childVCs: [UIViewController]
    private weak var parentVC: UIViewController?
    private var startOffsetX: CGFloat = 0
    private var isForbidScrollDelegate: Bool = false
    weak var delegate: PageContentViewDelegate?
    
    // 懒加载属性
    private lazy var collectionView: UICollectionView = {[weak self] in
        // 1.创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        
        return collectionView
    }()

    init(frame: CGRect, childVCs: [UIViewController], parentVC: UIViewController?) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        
        super.init(frame: frame)
        
        // 设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// 设置UI界面
extension PageContentView {
    private func setupUI() {
        // 1.将所有子控制器添加到父控制器中
        for childVC in childVCs {
            parentVC?.addChild(childVC)
        }
        
        // 2.添加UICollectionView, 用于在 item 中存放控制器的view
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

// 遵循UICollectionViewDatasource
extension PageContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        // 2.给cell设置内容
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childVC = childVCs[indexPath.item]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
    
    
}

// 遵循UICollectionViewDelegate
extension PageContentView : UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 0.判断是否禁止滚动
        if isForbidScrollDelegate { return }
        
        // 1.定义获取需要的数据
        var progress: CGFloat = 0
        var sourceIndex: Int = 0
        var targetIndex: Int = 0
        
        // 2.判断左滑右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX { // 左滑
            // 计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            // 计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            // 计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVCs.count {
                targetIndex = childVCs.count - 1
            }
            // 完全滑过去处理
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1.0
                targetIndex = sourceIndex
            }
        } else { // 右滑
            // 计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            // 计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            // 计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVCs.count {
                sourceIndex = childVCs.count - 1
            }
        }
        
        // 3.将progress/sourceIndex/targetIndex传递给titleView
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

// 对外暴露的方法
extension PageContentView {
    func setCurrentIndex(currentIndex: Int) {
        // 1.记录需要禁止滚动
        isForbidScrollDelegate = true
        
        // 2.滚到正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
        
    }
}
