//
//  Dictionary+JSON.swift
//  CoolMoive
//
//  Created by Jie on 2020/3/22.
//  Copyright © 2020 Jie. All rights reserved.
//

import Foundation

public extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    
    /// 转成字符串
    var toString: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}


