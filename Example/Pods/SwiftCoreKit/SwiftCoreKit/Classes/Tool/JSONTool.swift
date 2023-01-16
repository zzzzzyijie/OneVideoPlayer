//
//  JSONTool.swift
//  JianxiaozhiAI
//
//  Created by Jie on 2021/6/2.
//  Copyright © 2021 Jie. All rights reserved.
//

import UIKit

// https://www.advancedswift.com/swift-json-without-swiftyjson/

public class JSONTool: NSObject {
    
    // string --> dictionary
    public static func stringToDict(resp: Any?) -> [String: Any]? {
        var respDict: [String: Any]?
        if let bodyDict = resp as? [String: Any] {
            respDict = bodyDict
        }else if let bodyString = resp as? String {
            if let data =  bodyString.data(using: .utf8),
               let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                respDict = dict
            }
        }
        return respDict
    }
    
    // string --> Codable
    public static func stringToModel<T: Decodable>(_ type: T.Type, from resp: Any?) -> T? {
        var data: Data?
        if let dict = resp as? [String: Any] {
            data = try? JSONSerialization.data(withJSONObject: dict, options: [])
        }else if let string = resp as? String {
            data =  string.data(using: .utf8)
        }
        if let data = data {
            return try? JSONDecoder().decode(type, from: data)
        }
        return nil
    }
    
    // Codable model --> dictionary
    public static func modelToDict<T: Encodable>(_ model: T) -> [String: Any]? {
        if let data = try? JSONEncoder().encode(model) {
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            return json as? [String: Any]
        }
        return nil
    }
    
    // Codable model --> string
    public static func modelToString<T: Encodable>(_ model: T) -> String? {
        if let data = try? JSONEncoder().encode(model) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    // dict --> string
    public static func dictToString(_ dict: [String : Any]) -> String? {
             let data = try? JSONSerialization.data(withJSONObject: dict, options: [])
             let string = String(data: data!, encoding: String.Encoding.utf8)
             return string
         }
    
    // To Int value 
    public static func intValue(_ resp: Any?) -> Int? {
        if let value = resp as? Int {
            return value
        }else if let value = resp as? String {
            return Int(value)
        }
        return nil
    }
}
