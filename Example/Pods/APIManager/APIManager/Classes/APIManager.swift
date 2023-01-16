//
//  APIManager.swift
//  APIManager
//
//  Created by Jie on 2022/3/16.
//

import Foundation
import Alamofire

// ------------------------------ 请求管理者 --------------------------------------------
public class APIManager: Alamofire.SessionManager {
    
    // Status
    private(set) var netwrokStatus: NetwrokStatus = .unknown
    public var isDebugLog = false // 是否debug log
    private let networkManager = NetworkReachabilityManager(host: "www.apple.com")
    
    // 实例
    public static let share: APIManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let manager = APIManager(configuration: configuration)
        let adaptRetry = APIRequestAdaptRetrier()
        manager.retrier = adaptRetry
        return manager
    }()
    
    // 校验Requst
    open func validateRequest(_ urlRequest: URLRequestConvertible) -> DataRequest {
        return self.request(urlRequest).validate(validateData)
    }
    
    // --------------------------------------------------------------------------
    // 校验resp
    private func validateData(request: URLRequest?, response: HTTPURLResponse? , data: Data?) -> Request.ValidationResult {
        // statusCode
        let respMsg = response?.description
        log("🎈request ------ start ------------")
        log("🎈request url = \(request?.url?.absoluteString ?? "")")
        if let response = response , response.statusCode != 200 {
            let code = response.statusCode
            let msg = "\(code) 服务器异常"
            log("🎈request ------ end ❌ >>> statusCode != 200 -------")
            return .failure(ReqError.serverError(code: code, msg: msg,respones: respMsg))
        }
        
        // data为空
        guard let data = data else {
            log("🎈request ------ end ❌ >>> data 没有值 -------")
            return .failure(ReqError.unKnow(response?.description))
        }
        
        // Log
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            log("🎈request ------ end ❌ >>> 解析错误 -------")
            return .failure(ReqError.decodeFailure(respMsg))
        }
        log(json.logJSON)
        
        // 解析错误
        let decoder = JSONDecoder()
        guard let resp = try? decoder.decode(ValidateResp.self, from: data) else {
            log("🎈request ------ end ❌ >>> 解析错误 -------")
            return .failure(ReqError.decodeFailure(respMsg))
        }
        log("🎈request ------ end >>> ✅ -------")
        
        // 服务器定义的错误码校验
        // 1000 成功
        if resp.code == 1000 || resp.code == 1020 {
            return .success
        }else {
            return .failure(ReqError.serverError(code: resp.code, msg: resp.msg,respones: respMsg))
        }
    }
    
    // --------------------------------------------------------------------------
    // MARK: - 上传 ----------------------------
    // 上传文件
    open func uploadFileWith(data: Data,
                             to url: URLConvertible,
                             param: Parameters? = nil,
                             name: String,
                             fileName: String,
                             mimeType: String,
                             completion: ((Result<Data>) -> Void)?) {
        upload(multipartFormData: { multipartFormData in
            if let params = param {
                for p in params {
                    if let value = "\(p.value)".data(using: .utf8) {
                        multipartFormData.append(value, withName: p.key)
                    }
                }
            }
            multipartFormData.append(data, withName: name, fileName: fileName, mimeType: mimeType)
        }, to: url) { result in
            switch result {
            case .success(let request, _, _):
                request.responseJSON { response in
                    if let data = response.data {
                        completion?(.success(data))
                    }else {
                        let code = response.response?.statusCode ?? 0
                        let msg = response.description
                        let error = ReqError.serverError(code: code, msg: msg, respones: msg)
                        completion?(.failure(error))
                    }
                }
                break
            case .failure(let error):
                completion?(.failure(error))
                break
            }
        }
    }
    
    // --------------------------------------------------------------------------
    private func log(_ msg: String?) {
        if isDebugLog {
            print(msg ?? "")
        }
    }
    
    // --------------------------------------------------------------------------
    // MARK: - 下载 ----------------------------
    // 下载资源 ( 有点Objc风格，待完善
    @discardableResult
    open func download(url: String,
                       destinationPath: URL,
                       progressHander: @escaping (Progress) -> Void,
                       successHander: @escaping (Data,URL?) -> Void,
                       failureHander: @escaping (Error) -> Void) -> DownloadRequest {
       return download(url) { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
            return (destinationPath, [.removePreviousFile,.createIntermediateDirectories])
        }.downloadProgress { (progress) in
            progressHander(progress)
        }.responseData(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                successHander(data, response.destinationURL)
            break
            case .failure(let error):
                failureHander(error)
            break
            }
        })
    }
    
    // --------------------------------------------------------------------------
    // 开始网络监测
   static func startNetworkListening() {
        /// 网络监控
        let manager = APIManager.share
        manager.networkManager!.listener = { status in
            switch status {
            case .unknown:
                // 未知网络,请检查"
                manager.netwrokStatus = .unknown
               break
            case .notReachable:
                // 无法连接网络"
                manager.netwrokStatus = .unknown
              break
            case .reachable(.wwan):
                // 蜂窝移动网络"
                manager.netwrokStatus = .wwan
              break
            case .reachable(.ethernetOrWiFi):
                // "WIFI-网络,"
                manager.netwrokStatus = .wifi
              break
            }
            NotificationCenter.default.post(name: .APINetworkStatusDidChange, object: manager.netwrokStatus)
        }
        manager.networkManager!.startListening()
    }
}

// --------------------------------------------------------------------------
// 再次请求
class APIRequestAdaptRetrier: RequestRetrier {
    // https://rudybermudez.io/handing-network-problems-gracefully-with-alamofire retry sample
    // https://www.ojit.com/article/2366584 auth sample
    // [Request url: Number of times retried]
    private var retriedRequests: [String: Int] = [:]
    
    internal func should(_ manager: SessionManager,
                         retry request: Request,
                         with error: Error,
                         completion: @escaping RequestRetryCompletion) {
        
        guard  request.task?.response == nil, let url = request.request?.url?.absoluteString else {
            removeCachedUrlRequest(url: request.request?.url?.absoluteString)
            completion(false, 0.0) // don't retry
            return
        }
        
        // https://gist.github.com/krin-san/eb5cc692dcce9f2034bc8961cfc58694
        //let error = error as NSError
        if isErrorFatal(error: error) {
            debugPrint("Request failed with fatal error: %@ - Will not try again!",error.localizedDescription)
            completion(false, 0.0) // don't retry
            return
        }
        
        guard let retryCount = retriedRequests[url] else {
            retriedRequests[url] = 1
            debugPrint("retryCount = 1")
            completion(true, 0.0) // retry after 0 second
            return
        }
        
        if retryCount < 2 { // --- when this is 2 , then total 3 times
            retriedRequests[url] = retryCount + 1
            debugPrint("retryCount = \(String(describing: retriedRequests[url]))")
            completion(true, 0.0) // retry after 0 second
        } else {
            removeCachedUrlRequest(url: url)
            completion(false, 0.0) // don't retry
        }
    }
    
    // 移除 retried Requests
    private func removeCachedUrlRequest(url: String?) {
        guard let url = url else {
            return
        }
        retriedRequests.removeValue(forKey: url)
    }
    
    // 错误码检验
    private func isErrorFatal(error: Error) -> Bool {
        if error is ReqError {
            return true
        }
        // network error
        // others error
        let error = error as NSError
        switch error.code {
        case 102,3840:
            return true
        //case 500: // 假如 自定义 500为后端错误
        default:
            return false
        }
    }
    
}
