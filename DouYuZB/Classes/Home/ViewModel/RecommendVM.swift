//
//  RecommendVM.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/9/16.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit

class RecommendVM {
    // 组对象
    lazy var cycleModels: [CycleModel] = [CycleModel]()
    lazy var anchorGroups: [AnchorGroup] = [AnchorGroup]()
    private lazy var hotGroup: AnchorGroup = AnchorGroup()
    private lazy var faceGroup: AnchorGroup = AnchorGroup()
}

// 发送网络请求
extension RecommendVM {
    // 请求推荐数据
    func requestData(completion: @escaping () -> ()) {
        // 0.定义参数
        let paras = ["limit" : "4", "offset" : "0", "time" : NSDate.getCurrentTime()]
        
        let dGroup = DispatchGroup()
        // 1.请求第一部分推荐数据
        dGroup.enter()
        NetworkTool.requestData(type: .GET, urlString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time" : NSDate.getCurrentTime()]) { (result) in
            print(result)
            
            guard let resultDict = result as? [String : NSObject] else {
                dGroup.leave()
                return
            }
            
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else {
                dGroup.leave()
                return
            }
            
            // 创建组
            self.hotGroup.tag_name = "热门"
            self.hotGroup.icon_name = "home_header_hot"
            
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.hotGroup.anchors.append(anchor)
            }
            dGroup.leave()
        }
        
        // 2.请求第二部分颜值数据
        dGroup.enter()
        NetworkTool.requestData(type: .GET, urlString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: paras) { (result) in
            // print(result)
            
            guard let resultDict = result as? [String : NSObject] else {
                dGroup.leave()
                return
            }
            
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else {
                dGroup.leave()
                return
            }
            
            // 创建组
            self.faceGroup.tag_name = "颜值"
            self.faceGroup.icon_name = "home_header_phone"
            
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.faceGroup.anchors.append(anchor)
            }
            dGroup.leave()
        }
        
        // 3.请求后面部分游戏数据
        dGroup.enter()
        NetworkTool.requestData(type: .GET, urlString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: paras) { (result) in
            
            // 1.将 result 转成字典类型
            guard let resultDict = result as? [String : NSObject] else {
                dGroup.leave()
                return
            }
            
            // 2.根据 data 获取数组
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else {
                dGroup.leave()
                return
            }
            
            // 3.遍历数组，获取字典，并将字典转成模型对象
            for dict in dataArray {
                let group = AnchorGroup(dict: dict)
                self.anchorGroups.append(group)
            }
            /*
            for group in self.anchorGroups {
                for anchor in group.anchors {
                    
                }
            }
            */
            dGroup.leave()
        }
        
        dGroup.notify(queue: DispatchQueue.main) {
            self.anchorGroups.insert(self.faceGroup, at: 0)
            self.anchorGroups.insert(self.hotGroup, at: 0)
            completion()
        }
    }
}

extension RecommendVM {
    // 请求无限轮播数据
    func requestCycleData(completion: @escaping () -> ()) {
        NetworkTool.requestData(type: .GET, urlString: "http://www.douyutv.com/api/v1/slide/6", parameters: ["version" : "2.300"]) { (result) in
            // 1.获取整体字典数据
            guard let resultDict = result as? [String : NSObject] else { return }
            // 2.根据data的key获取数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3.字典转模型对象
            for dict in dataArray {
                self.cycleModels.append(CycleModel(dict: dict))
            }
            
            completion()
        }
    }
}
