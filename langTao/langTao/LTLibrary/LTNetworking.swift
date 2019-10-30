//
//  LTNetworking.swift
//  YYProject
//
//  Created by haozhiyu on 2018/11/18.
//  Copyright © 2018年 haozhiyu. All rights reserved.
//

import UIKit
import Moya
import Alamofire

struct BaseModel: Codable {
    var flag: Bool
    var code: Int
    var message: String
}

let networkPlugin = NetworkActivityPlugin { (networkActivityChangeType, _) in
    switch networkActivityChangeType {
    case .began:
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    case .ended:
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }        
}

typealias YYCompletion = (LTNetworking.Result<Data, LTNetworking.YYError>) -> ()

class LTNetworking: NSObject {
    enum Result<Success, Failure> where Failure: Error {
        case success(Success)
        case failure(Failure)
    }
    
    struct YYError: Error {
        var errorCode: Int?
        var message: String
    }
    
    @discardableResult
    class func loadData<T: TargetType>(API: T.Type, target: T, cache: Bool = false, cacheHandle: ((Data) -> Void)? = nil, progress: ((Double) -> Void)? = nil, completion: @escaping YYCompletion) -> Cancellable? {

        //如果需要读取缓存，则优先读取缓存内容
        if cache, let data = YYSaveFiles.read(path: target.path) {
            //cacheHandle不为nil则使用cacheHandle处理缓存，否则使用success处理
            if let block = cacheHandle {
                block(data)
            } else {
                completion(.success(data))
            }
        } else {
            //读取缓存速度较快，无需显示hud；仅从网络加载数据时，显示hud。
            LTHUD.show()
        }
        
        if let isReachable = NetworkReachabilityManager()?.isReachable, isReachable == false {
            LTHUD.hide()
            LTHUD.show(type: .error, text: "Network anomalies".localString)
            completion(.failure(YYError(errorCode: nil, message: "Network anomalies".localString)))
            return nil
        }
        
        let provider = MoyaProvider<T>(plugins: [RequestHandlingPlugin(), networkPlugin])
        let cancellable = provider.request(target, progress: { progressT in
            progress?(progressT.progress)
        }) { result in
            LTHUD.hide()
            switch result {
            case let .success(response):
                printResponse(response: response, target: target)

                guard let res = try? JSONDecoder().decode(BaseModel.self, from: response.data) else {
                    failureHandle(completion: completion, stateCode: nil, message: "Data parsing failure".localString)
                    return
                }
                if !res.flag {
                    // token 失效
                    if res.code == 20006 {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: TOKENINVALID), object: nil)
                        UserDefaults.standard.removeObject(forKey: USERMODELCACHE)
                        UserDefaults.standard.synchronize()
                    }
                    failureHandle(completion: completion, stateCode: res.code, message: res.message)
                    return
                }
                
                if cache {
                    //缓存
                    YYSaveFiles.save(path: target.path, data: response.data)
                }
                completion(.success(response.data))
            case let .failure(error):
                printResponse(response: error.response, target: target)
                
                //请求数据失败，可能是404（无法找到指定位置的资源），408（请求超时）等错误
                //可百度查找“http状态码”
                let statusCode = error.response?.statusCode
                let errorCode = "Unknown error".localString
                failureHandle(completion: completion, stateCode: statusCode, message: error.errorDescription ?? errorCode)
            }
        }
        
        //错误处理 - 弹出错误信息
        func failureHandle(completion: YYCompletion , stateCode: Int?, message: String) {
            LTHUD.show(type: .error, text: message)
            completion(.failure(YYError(errorCode: stateCode, message: message)))
        }
        
        func printResponse(response: Response?, target: T) {
            #if DEBUG
            if let requrl = response?.request?.url {
                switch target.method {
                case .get:
                    print(requrl)
                default:
                    let str = "\(target.task)"
                    if let first = str.firstIndex(of: "["), let last = str.lastIndex(of: "]") {
                        var sub = String(str[first..<last])
                        sub = sub.replacingOccurrences(of: "https:", with: "§")
                        sub = sub.replacingOccurrences(of: "http:", with: "¢")
                        sub = sub.replacingOccurrences(of: "file:", with: "ƒ")
                        sub = sub.replacingOccurrences(of: " ", with: "")
                        sub = sub.replacingOccurrences(of: "[", with: "")
                        sub = sub.replacingOccurrences(of: ":", with: "=")
                        sub = sub.replacingOccurrences(of: "§", with: "https:")
                        sub = sub.replacingOccurrences(of: "¢", with: "http:")
                        sub = sub.replacingOccurrences(of: "ƒ", with: "file:")
                        sub = sub.replacingOccurrences(of: ",", with: "&")
                        sub = sub.replacingOccurrences(of: "\"", with: "")
                        if requrl.absoluteString.contains("?") {
                            print(requrl.absoluteString+"&"+sub)
                        } else {
                            print(requrl.absoluteString+"?"+sub)
                        }
                    } else {
                        print(requrl)
                    }
                }
            }
            
            print(String(data: response?.data ?? Data(), encoding: String.Encoding.utf8) ?? "")
            #endif
        }
        
        return cancellable
    }
}
