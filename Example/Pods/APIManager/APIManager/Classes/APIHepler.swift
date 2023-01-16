//
//  APIResp.swift
//  APIManager
//
//  Created by Jie on 2022/3/16.
//

import Foundation

// --------------------------------------------------------------------------
// 用于校验返回数据及错误码信息（ 需要和后端协定, 为什么不用下面的Response呢？ 因为data没有值的话，可能会解析错误
public struct ValidateResp: Codable {
    let code: Int
    let msg: String?
}

// --------------------------------------------------------------------------
// 网络状态
enum NetwrokStatus {
    case unknown // 没网或未知
    case wwan    // 蜂窝移动网络
    case wifi    // wifi
}

// 网络状态通知
extension Notification.Name {
    // 网络状态改变
    static let APINetworkStatusDidChange = NSNotification.Name(rawValue: "APINetworkStatusDidChange")
}

// --------------------------------------------------------------------------
// 打印JSON
extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    // json
    public var logJSON: String {
        do {
            var dic: [String: Any] = [String: Any]()
            for (key, value) in self {
                dic["\(key)"] = value
            }
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)

            if let data = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as String? {
                return data.replacingOccurrences(of: "\\", with: "") // 这里简单暴力的把 反斜杠\去掉，需留意具体情况
            } else {
                return "{}"
            }
        } catch {
            return "{}"
        }
    }
}
