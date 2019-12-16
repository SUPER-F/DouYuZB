//
//  AmuseVM.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/11/18.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit

class AmuseVM {
    lazy var anchorGroups: [AnchorGroup] = [AnchorGroup]()
}

extension AmuseVM {
    func loadAmuseData(finishedCallback: @escaping () -> ()) {
        NetworkTool.requestData(type: .GET, urlString: "http://capi.douyucdn.cn/api/v1/getHotRoom/2") { (result) in
            // 1.对数据进行处理
            guard let resultDict = result as? [String : Any] else { return }
            guard let dataArray = resultDict["data"] as? [[String : Any]] else { return }
            
            // 2.遍历数组中的字典
            for dict in dataArray {
                self.anchorGroups.append(AnchorGroup(dict: dict))
            }
            
            // 3.完成回调
            finishedCallback()
        }
    }
}
