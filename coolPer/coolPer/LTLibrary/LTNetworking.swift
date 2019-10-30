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
import YYFast

let networkPlugin = NetworkActivityPlugin { (networkActivityChangeType, _) in
    switch networkActivityChangeType {
    case .began:
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    case .ended:
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }        
}

class LTNetworking: NSObject {
    class func loadData<T: TargetType>(API: T.Type, target: T, cache: Bool = false, cacheHandle: ((Data) -> Void)? = nil, progress: ((Double) -> Void)? = nil, failure: ((Int?, String) -> Void)? = nil, success:@escaping ((Data) -> Void)) {
        
        //如果需要读取缓存，则优先读取缓存内容
        if cache, let data = YYSaveFiles.read(path: target.path) {
            //cacheHandle不为nil则使用cacheHandle处理缓存，否则使用success处理
            if let block = cacheHandle {
                block(data)
            } else {
                success(data)
            }
        } else {
            //读取缓存速度较快，无需显示hud；仅从网络加载数据时，显示hud。
            LTHUD.show()
        }
        
        if let isReachable = NetworkReachabilityManager()?.isReachable, isReachable == false {
            LTHUD.show(type: .error, text: "网络异常")
            failure?(nil, "网络异常")
            return
        }
        
        let provider = MoyaProvider<T>(plugins: [RequestHandlingPlugin(), networkPlugin])
        
        provider.request(target, progress: { progressT in
            progress?(progressT.progress)
        }) { result in
            LTHUD.hide()
            switch result {
            case let .success(response):                
                printResponse(response: response, target: target)
                
                if cache {
                    //缓存
                    YYSaveFiles.save(path: target.path, data: response.data)
                }
                success(response.data)
            case let .failure(error):
                printResponse(response: error.response, target: target)
                
                //请求数据失败，可能是404（无法找到指定位置的资源），408（请求超时）等错误
                //可百度查找“http状态码”
                let statusCode = error.response?.statusCode
                let errorCode = "未知错误"
                failureHandle(failure: failure, stateCode: statusCode, message: error.errorDescription ?? errorCode)
            }
        }
        
        //错误处理 - 弹出错误信息
        func failureHandle(failure: ((Int?, String) -> Void)? , stateCode: Int?, message: String) {
            LTHUD.show(type: .error, text: message)
            failure?(stateCode, message)
        }
        
        func printResponse(response: Response?, target: T) {
            if let requrl = response?.request?.url {
                switch target.method {
                case .post:
                    let str = "\(target.task)"
                    if let first = str.firstIndex(of: "["), let last = str.lastIndex(of: "]") {
                        var sub = String(str[first..<last])
                        sub = sub.replacingOccurrences(of: " ", with: "")
                        sub = sub.replacingOccurrences(of: "[", with: "")
                        sub = sub.replacingOccurrences(of: ":", with: "=")
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
                default:
                    print(requrl)
                }
            }
            
            print(String(data: response?.data ?? Data(), encoding: String.Encoding.utf8) ?? "")
        }
    }
}
