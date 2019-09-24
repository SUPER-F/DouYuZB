//
//  NetworkTool.swift
//  DouYuZB
//
//  Created by chaofei song on 2019/9/16.
//  Copyright © 2019 zpit. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case GET
    case POST
}

class NetworkTool {
    static func requestData(type: MethodType, urlString: String, parameters: [String : String]? = nil, completion: @escaping (_ result: Any) -> ()) {
        // 1.获取类型
        let methodType = type == .GET ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
        Alamofire.request(urlString, method: methodType, parameters: parameters).responseJSON { (resopnse) in
            // 3.获取结果
            guard let result = resopnse.result.value else {
                print(resopnse.result.error as Any)
                return
            }
            
            // 4.将结果回调出去
            completion(result)
        }
    }
}
