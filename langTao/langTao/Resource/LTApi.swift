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

extension String {
    var url: URL? {
        if hasPrefix("http://") || hasPrefix("https://") {
            return URL(string: self)
        }
        return LTAPI.fileHost.baseURL.appendingPathComponent(self)
    }
}

//TargetType协议可以一次性处理的参数
//根据自己的需要更改，不能统一处理的移除下面的代码
public extension TargetType {
    var baseURL: URL {
        return URL(string: "http://langte.enenterprise.ltetek.com")!
//        return URL(string: "http://192.168.1.191:9003")!
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
}

enum LTAPI {
    /// 获取验证码 sort 1注册 2找回密码 3修改手机号
    case getCode(sort: String, mobile: String)
    /// 注册
    case register(code: String, param: [String : String])
    /// 登录
    case login(param: [String : String])
    /// 找回密码 或 修改手机号
    case findPasswordAndModify(code: String, param: [String : String])
    /// 修改用户信息
    case modiyUserinfo(param: [String : String])
    /// 上传文件接口 code 1用户头像 2商家Logo保存 3商品主图 4商品附图 5商品视频 6营业执照 7广告图
    case uploadingFile(code: String, param: [String : MultipartFormData.FormDataProvider])
    /// 意见反馈
    case advise(param: [String : String])
    /// 根据浏览量查询热门产品列表
    case productVisits
    /// 根据创建时间查询最新产品列表
    case productCreatetime
    /// 根据商家分类查询商家排名列表 (sort 1 电子烟品牌， 2 供应商， 3 蓝牙产品...  子类产品传子类id)
    case enterpriseSort(sort: String)
    /// 根据parentId查询分类
    case sortParentId(parentId: String)
    /// 根据条件查询产品列表列表
    case sortSearchByClass(className: String)
    /// 分类全部列表
    case allSort
    /// 搜索产品分页
    case productSearchPage(page: Int, size: Int, param: [String : String])
    /// Enterprise分页
    case enterpriseSearchPage(page: Int, size: Int, param: [String : String])
    /// 根据商家id查询商家信息
    case enterpriseById(id: String)
    /// 根据userID查询用户信息
    case userById(userId: String)
    /// 增加商家
    case addEnterprise(param: [String : String])
    /// 修改商家
    case modifEnteriseById(id: String, param: [String : String])
    /// 根据批量查询分类
    case sortByIds(sortIds: String)
    /// 根据ID查询分类（并查询产品信息）
    case sortById(sortId: String)
    /// 增加产品
    case addProduct(param: [String : String])
    /// 修改产品
    case modifProductById(productId: String, param: [String : String])
    /// 根据ID删除产品
    case deleteProductById(productId: String)
    /// 文件的域名
    case fileHost
}

extension LTAPI: TargetType {
    var method: Moya.Method {
        switch self {
        case .findPasswordAndModify, .modiyUserinfo, .modifEnteriseById, .modifProductById:
            return .put
        case .productVisits, .productCreatetime, .enterpriseSort, .sortParentId, .allSort, .enterpriseById, .userById, .sortByIds, .sortById:
            return .get
        case .deleteProductById:
            return .delete
        default:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .fileHost:
            return ""
        case .getCode(let sort, let mobile):
            return "/user/sendsms/\(sort)/\(mobile)"
        case .register(let code, _):
            return "/user/register/\(code)"
        case .login:
            return "/user/login"
        case .findPasswordAndModify(let code, _):
            return "/user/\(code)"
        case .modiyUserinfo:
            return "/user/saveinfo"
        case .uploadingFile(let code, _):
            return "/qiniu/imgs/\(code)"
        case .advise:
            return "/advise"
        case .productVisits:
            return "/product/visits/search"
        case .productCreatetime:
            return "/product/createtime/search"
        case .enterpriseSort(let sort):
            return "/enterprise/sort/\(sort)"
        case .sortParentId(let parentId):
            return "/sort/parentId/\(parentId)"
        case .sortSearchByClass(let className):
            return "/sort/search/\(className)"
        case .allSort:
            return "/sort"
        case .productSearchPage(let page, let size, _):
            return "/product/search/\(page)/\(size)"
        case .enterpriseSearchPage(let page, let size, _):
            return "/enterprise/search/\(page)/\(size)"
        case .enterpriseById(let id):
            return "/enterprise/\(id)"
        case .userById(let userId):
            return "/user/\(userId)"
        case .addEnterprise:
            return "/enterprise"
        case .modifEnteriseById(let id, _):
            return "/enterprise/\(id)"
        case .sortByIds(let sortIds):
            return "/sort/list/\(sortIds)"
        case .addProduct:
            return "/product"
        case .sortById(let sortId):
            return "/sort/\(sortId)"
        case .modifProductById(let productId, _):
            return "/product/\(productId)"
        case .deleteProductById(let productId):
            return "/product/\(productId)"
        }
    }
    
    var task: Task {
        var params: [String: String] = [:]
        
        switch self {
        case .register(_, let param), .login(let param), .findPasswordAndModify(_, let param), .modiyUserinfo(let param), .advise(let param), .productSearchPage(_, _, let param), .enterpriseSearchPage(_, _, let param), .addEnterprise(let param), .modifEnteriseById(_, let param), .addProduct(let param), .modifProductById(_, let param):
            params = param
        case .uploadingFile(_, let param):
            var formDatas = [MultipartFormData]()
            for (key, value) in param {
                switch value {
                case .data:
                    let formData = MultipartFormData(provider: value, name: "image", fileName: key, mimeType: "image/png")
                    formDatas.append(formData)
                case .file:
                    let formData = MultipartFormData(provider: value, name: "image", fileName: key, mimeType: "video/mp4")
                    formDatas.append(formData)
                case .stream:
                    break
                }
            }
            return .uploadMultipart(formDatas)
        default:
            //不需要传参数的接口走这里
            return .requestPlain
        }
        
        //Task是一个枚举值，根据后台需要的数据，选择不同的http task。 
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
    
    var headers: [String : String]? {
        switch self {
        case .addEnterprise, .enterpriseById, .modifEnteriseById:
            guard let token = LTUserViewModel.shared.user?.data.token else {
                return nil
            }
            return ["Authorization" : "Bearer "+token]
        default:
            return nil
        }
    }
}
