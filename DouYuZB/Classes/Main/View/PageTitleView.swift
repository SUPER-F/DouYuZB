//
//  PageTitleView.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/8/19.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit

// 定义协议
protocol PageTitleViewDelegate : class {
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int)
}

// 定义常量
private let kScrollLineH: CGFloat = 2
private let kNormalColor: (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor: (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

class PageTitleView : UIView {
    // 定义属性
    private var titles: [String]
    private var currentIndex: Int = 0
    weak var delegate: PageTitleViewDelegate?
    
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
        scrollLine.backgroundColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
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
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            
            // 3.设置label的frame
            let labelX: CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            // 4.添加label到scrollView
            scrollView.addSubview(label)
            
            // 5.添加label到label数组
            titleLabels.append(label)
            
            // 6.给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    private func setupScrollLine() {
        // 1.获取第一个label
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        // 2.设置scrollLine属性
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
        scrollView.addSubview(scrollLine)
    }
}

// 监听label的点击
extension PageTitleView {
    @objc private func titleLabelClick(tapGes: UITapGestureRecognizer) {
        // 1.获取当前label
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        if currentIndex == currentLabel.tag { return }
        
        // 2.获取之前的label
        let oldLabel = titleLabels[currentIndex]
        
        // 3.切换文字颜色
        currentLabel.textColor = UIColor.orange
        oldLabel.textColor = UIColor.darkGray
        
        // 4.保存最新点击label的下标值
        currentIndex = currentLabel.tag
        
        // 5.滚动条位置发生改变
        let scrollLineX = CGFloat(currentIndex) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        // 6.通知代理
        delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
    }
}

// 对外暴露方法
extension PageTitleView {
    func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2.处理滑块逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        // 3.处理颜色的渐变
        // 3.1.取出变化范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        // 3.2.变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        // 3.3.变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        // 4.记录最新的index
        currentIndex = targetIndex
    }
}
