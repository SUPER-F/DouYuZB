//
//  PageTitleView.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/8/19.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit

let kScrollLineH: CGFloat = 2

class PageTitleView: UIView {
    // 定义属性
    private var titles: [String]
    
    // 懒加载属性
    private lazy var titleLabels: [UILabel] = [UILabel]()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    private lazy var titleBottomLine: UIView = {
        let titleBottomLine = UIView()
        titleBottomLine.backgroundColor = UIColor.lightGray
        return titleBottomLine
    }()

    // 自定义构造函数
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        
        super.init(frame: frame)
        
        // 设置UI界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// 设置UI界面
extension PageTitleView {
    private func setupUI() {
        // 1.添加UIScrollView
        setupScrollView()
        
        // 2.添加titleView底部横线
        setupTitleBottomLine()
        
        // 3.添加title对应的label
        setupTitleLabels()
        
        // 4.添加底部滑块
        setupScrollLine()
    }
    
    private func setupScrollView() {
        scrollView.frame = bounds
        addSubview(scrollView)
    }
    
    private func setupTitleBottomLine() {
        titleBottomLine.frame = CGRect(x: 0, y: frame.height - 0.5, width: frame.width, height: 0.5)
        addSubview(titleBottomLine)
    }
    
    private func setupTitleLabels() {
        // 0.确定label的一些固定frame值
        let labelW: CGFloat = frame.width / CGFloat(titles.count)
        let labelH: CGFloat = frame.height - kScrollLineH
        let labelY: CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            // 1.创建label
            let label = UILabel()
            
            // 2.设置label的属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor.darkGray
            label.textAlignment = .center
            
            // 3.设置label的frame
            let labelX: CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            // 4.添加label到scrollView
            scrollView.addSubview(label)
            
            // 5.添加label到label数组
            titleLabels.append(label)
        }
    }
    
    private func setupScrollLine() {
        // 1.获取第一个label
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor.orange
        
        // 2.设置scrollLine属性
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
        scrollView.addSubview(scrollLine)
    }
}
