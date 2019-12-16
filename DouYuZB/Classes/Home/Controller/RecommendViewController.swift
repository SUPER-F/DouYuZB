//
//  RecommendViewController.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/8/26.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit

private let kItemMargin: CGFloat = 10
private let kItemW: CGFloat = (kScreenW - 3 * kItemMargin) / 2.0
private let kItemNormalH: CGFloat = kItemW * 3 / 4.0
private let kItemPrettyH: CGFloat = kItemW * 4 / 3.0
private let kHeaderViewH: CGFloat = 50
private let kCycleViewH: CGFloat = kScreenW * 3 / 8.0
private let kGameViewH: CGFloat = 90

private let kNormalCellID = "kNormalCellID"
private let kPrettyCellID = "kPrettyCellID"
private let kHeaderViewID = "kHeaderViewID"

class RecommendViewController: UIViewController {
    // 1.懒加载属性
    private lazy var recommendVM: RecommendVM = RecommendVM()
    
    private lazy var collectionView: UICollectionView = {[unowned self] in
        // 1.创建布局
        let layout = UICollectionViewFlowLayout()
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
    
    private lazy var cycleView: RecommendCycleView = {
        let cycleView = RecommendCycleView.recommendCycleView()
        cycleView.frame = CGRect(x: 0, y: -(kCycleViewH + kGameViewH), width: kScreenW, height: kCycleViewH)
        
        return cycleView
    }()
    
    private lazy var gameView: RecommendGameView = {
        let gameView = RecommendGameView.recommendGameView()
        gameView.frame = CGRect(x: 0, y: -kGameViewH, width: kScreenW, height: kGameViewH)
        return gameView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置UI界面
        setupUI()
        
        // 请求数据
        loadData()
    }

}

// 设置UI界面内容
extension RecommendViewController {
    private func setupUI() {
        view.backgroundColor = UIColor.white
        
        // 添加collectionview
        view.addSubview(collectionView)
        
        // 添加cycleview
        collectionView.addSubview(cycleView)
        
        // 添加gameView
        collectionView.addSubview(gameView)
        
        // 设置collectionview内边距
        collectionView.contentInset = UIEdgeInsets(top: kCycleViewH + kGameViewH, left: 0, bottom: 0, right: 0)
    }
}

// 请求数据
extension RecommendViewController {
    private func loadData() {
        // 请求推荐数据
        recommendVM.requestData {
            // 1.刷新列表
            self.collectionView.reloadData()
            
            // 2.给gameView 赋值
            var groups = self.recommendVM.anchorGroups
            // 2.1.移除前两组数据
            groups.removeFirst()
            groups.removeFirst()
            
            // 2.2.添加更多按钮
            let moreGroup = AnchorGroup()
            moreGroup.tag_name = "更多"
            groups.append(moreGroup)
            
            self.gameView.groups = groups
        }
        // 请求轮播数据
        recommendVM.requestCycleData {
            self.cycleView.cycleModels = self.recommendVM.cycleModels
        }
    }
}

// 遵守UICollectionViewDataSource协议
extension RecommendViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: kItemW, height: kItemPrettyH)
        }
        return CGSize(width: kItemW, height: kItemNormalH)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recommendVM.anchorGroups.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let group = recommendVM.anchorGroups[section]
        return group.anchors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 取出模型对象
        let group = recommendVM.anchorGroups[indexPath.section]
        let anchor = group.anchors[indexPath.item]
        
        // 定义cell
        var cell: CollectionBaseCell

        if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath) as! CollectionPrettyCell
            
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell
           
        }
        cell.anchor = anchor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        headerView.group = recommendVM.anchorGroups[indexPath.section]
        return headerView
    }
}

extension RecommendViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1.取出对应的主播信息
        let anchor = recommendVM.anchorGroups[indexPath.section].anchors[indexPath.item]
        
        //2.判断是秀场直播|普通直播
        anchor.isVertical == 0 ? pushNormalRoomVC() : presentShowRoomVC()
    }
    
    private func presentShowRoomVC() {
        // 1.创建秀场直播VC
        let showRoomVC = RoomShowViewController()
//        showRoomVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        // 2.以modal方式跳转
        present(showRoomVC, animated: true, completion: nil)
    }
    
    private func pushNormalRoomVC() {
        // 1.创建普通直播VC
        let normalRoomVC = RoomNormalViewController()
        
        // 2.以push方式跳转
        navigationController?.pushViewController(normalRoomVC, animated: true)
    }
}
