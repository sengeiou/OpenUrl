//
//  LTAPI.swift
//  YYProject
//
//  Created by haozhiyu on 2018/11/18.
//  Copyright © 2018年 haozhiyu. All rights reserved.
//

import UIKit
import Moya

// --- 公共参数 ----
class RequestHandlingPlugin: PluginType {
    
    /// Called to modify a request before sending
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var mutateableRequest = request
        return mutateableRequest.appendCommonParams();
    }
}

extension URLRequest {
    
    /// global common params
    private var commonParams: [String: Any] {
        //所有接口的公共参数添加在这里
        return [:]
    }
    
    mutating func appendCommonParams() -> URLRequest {
        let request = try? encoded(parameters: commonParams, parameterEncoding: URLEncoding(destination: .queryString))
        assert(request != nil, "append common params failed, please check common params value")
        return request!
    }
    
    func encoded(parameters: [String: Any], parameterEncoding: ParameterEncoding) throws -> URLRequest {
        do {
            return try parameterEncoding.encode(self, with: parameters)
        } catch {
            throw MoyaError.parameterEncoding(error)
        }
    }
}

// --- 公共参数end ----

//TargetType协议可以一次性处理的参数
//根据自己的需要更改，不能统一处理的移除下面的代码
public extension TargetType {
    var baseURL: URL {
        return URL(string: "http://app.u17.com/v3/appV3_3/ios/phone/")!
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var method: Moya.Method {
        return .post
    }
}

enum  LTAPI {
    //排行榜
    case rankList
    
    ///其他接口...
    case other1(param: String)
    case other2
    
}

extension LTAPI: TargetType {
    
    var path: String {
        switch self {
        case .rankList:
            return "rank/list"
        case .other1:
            return ""
        case .other2:
            return ""
        }
    }
    
    var task: Task {
        var params: [String: Any] = [:]
        
        switch self {
        case let .other1(param):
            params["param"] = param
        default:
            //不需要传参数的接口走这里
            return .requestPlain
        }
        
        //Task是一个枚举值，根据后台需要的数据，选择不同的http task。
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
}
