//
//  APIError.swift
//  APIManager
//
//  Created by Jie on 2022/3/16.
//

import Foundation

// --------------------------------------------------------------------------
// 错误信息 ( 包括请求错误、解析错误、后端返回错误
public enum ReqError: Error {
    case unKnow(_ respones: String?)
    case decodeFailure(_ respones: String?)
    case faileRequest(_ respones: String?)
    case serverError(code:Int, msg: String?,respones: String?) // 这里为什么使用可选？ 因为服务器可能不返回错误描述,看情况,一般不会
    
    public var serverCode: Int {
        switch self {
        case .serverError(let code, _,_):
            return code
        default:
            return 0
        }
    }
    
    // 用于上传log等 （ 所以也也是为什么 serverError 记录两个msg, 待完善
    public var responseMsg: String? {
        switch self {
        case .unKnow(let msg):
            return "服务器异常: \(msg ?? "")"
        case .decodeFailure(let msg):
            return "服务器异常: \(msg ?? "")"
        case .faileRequest(let msg):
            return "请求服务器失败: \(msg ?? "")"
        case .serverError(let code,let msg,let msg2):
            return "服务器错误 \(code) \(msg ?? ""): \(msg2 ?? "")"
        }
    }
}

// 请求的错误 errorDescription
// 用于页面占位显示的文案等
extension ReqError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unKnow(_):
            return "服务器异常"
        case .decodeFailure(_):
            return "数据解析失败"
        case .faileRequest(_):
            return "请求服务器失败"
        case .serverError(_, let msg,_):
            return msg
        }
    }
}
