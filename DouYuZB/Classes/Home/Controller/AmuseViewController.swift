//
//  AmuseViewController.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/11/18.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit

private let kItemMargin: CGFloat = 10
private let kItemW: CGFloat = (kScreenW - 3 * kItemMargin) / 2.0
private let kItemNormalH: CGFloat = kItemW * 3 / 4.0
private let kItemPrettyH: CGFloat = kItemW * 4 / 3.0
private let kHeaderViewH: CGFloat = 50
private let kAmuseMenuViewH: CGFloat = 200

private let kNormalCellID = "kNormalCellID"
private let kPrettyCellID = "kPrettyCellID"
private let kHeaderViewID = "kHeaderViewID"

class AmuseViewController: UIViewController {
    
    // 懒加载属性
    fileprivate lazy var amuseVM: AmuseVM = AmuseVM()
    fileprivate lazy var collectionView: UICollectionView = {[unowned self] in
        // 1.创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kItemNormalH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        // 2.创建UICollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // 注意：出现多次崩溃，原因是 xib 文件中外部多了一个label
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        return collectionView
    }()
    fileprivate lazy var amuseMenuView: AmuseMenuView = {
        let amuseMenuView = AmuseMenuView.amuseMenuView()
        amuseMenuView.frame = CGRect(x: 0, y: -kAmuseMenuViewH, width: kScreenW, height: kAmuseMenuViewH)
        return amuseMenuView;
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupUI()
        loadData()
    }

}

// 设置UI界面
extension AmuseViewController {
    fileprivate func setupUI() {
        view.addSubview(collectionView)
        
        collectionView.addSubview(amuseMenuView)
        collectionView.contentInset = UIEdgeInsets(top: kAmuseMenuViewH, left: 0, bottom: 0, right: 0)
    }
}

// 请求数据
extension AmuseViewController {
    fileprivate func loadData() {
        amuseVM.loadAmuseData {
            self.collectionView.reloadData()
            
            var tempGroups = self.amuseVM.anchorGroups
            tempGroups.removeFirst()
            self.amuseMenuView.groups = tempGroups
        }
    }
}

// 遵守 UICollectionView 的数据源协议 & 代理协议
extension AmuseViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return amuseVM.anchorGroups.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amuseVM.anchorGroups[section].anchors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.取出cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell
        
        // 2.给cell设置数据
        cell.anchor = amuseVM.anchorGroups[indexPath.section].anchors[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        headerView.group = amuseVM.anchorGroups[indexPath.section]
        return headerView
    }
    
    
}
