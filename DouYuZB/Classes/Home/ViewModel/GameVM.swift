//
//  GameVM.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/11/17.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit

class GameVM {
    lazy var games: [GameModel] = [GameModel]()
}

extension GameVM {
    func loadAllGameData(finfshedCallback: @escaping () -> ()) {
        NetworkTool.requestData(type: .POST, urlString: "http://capi.douyucdn.cn/api/v1/getColumnDetail", parameters: ["shortName" : "game"]) { (result) in
            // 1.获取数据
            guard let resultDict = result as? [String : Any] else { return }
            guard let dataArray = resultDict["data"] as? [[String : Any]] else { return }
            
            // 2.字典转模型
            for dict in dataArray {
                self.games.append(GameModel(dict: dict))
            }
            
            // 3.完成回调
            finfshedCallback()
        }
    }
}
