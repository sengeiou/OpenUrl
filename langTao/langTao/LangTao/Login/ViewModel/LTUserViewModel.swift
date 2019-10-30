//
//  LTUserViewModel.swift
//  langTao
//
//  **********************************************
//  *     _    _        _ˍ_ˍ_        _    _      *
//  *    | |  | |      |__   |      \ \  / /     *
//  *    | |__| |        /  /        \ \/ /      *
//  *    |  __  |       /  /          \  /       *
//  *    | |  | |      /  /__       __/ /        *
//  *    |_|  |_|      |_ˍ_ˍ_|     |_ˍ_/         *
//  *                                            *
//  **********************************************
//
//  Created by LonTe on 2019/8/12.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

class LTUserViewModel: NSObject {
    static let shared = LTUserViewModel()
    private override init() { }
    var user: LTUserModel? {
        if let data = UserDefaults.standard.data(forKey: USERMODELCACHE) {
            guard let iUser = try? JSONDecoder().decode(LTUserModel.self, from: data) else {
                return nil
            }
            return iUser
        }
        return nil
    }
    var updataImgs: [String]?
    
    /// 获取验证码 sort 1注册 2找回密码 3修改手机号
    func getCode(sort: String, mobile: String, completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .getCode(sort: sort, mobile: mobile)) { result in
            completion(result)
        }
    }
    /// 注册
    func register(code: String, param: [String : String], completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .register(code: code, param: param)) { result in
            completion(result)
        }
    }
    /// 登录
    func login(param: [String : String], completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .login(param: param)) { result in
            if case .success(let data) = result {
                guard let model = try? JSONDecoder().decode(LTUserModel.self, from: data) else {
                    LTHUD.show(type: .error, text: "Data parsing failure".localString)
                    return
                }
                UserDefaults.standard.set(model.data.user.mobile, forKey: USERMODELMODILE)
                UserDefaults.standard.set(data, forKey: USERMODELCACHE)
                UserDefaults.standard.synchronize()
            }
            completion(result)
        }
    }
    /// 找回密码 或 修改手机号
    func findPasswordAndModifyPhoto(code: String, param: [String : String], completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .findPasswordAndModify(code: code, param: param)) { result in
            completion(result)
        }
    }
    /// 修改用户信息
    func modiyUserinfo(param: [String : String], completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .modiyUserinfo(param: param)) { result in
            completion(result)
        }
    }
    /// 上传文件接口 code 1用户头像 2商家Logo保存 3商品主图 4商品附图 5商品视频 6营业执照 7广告图
    func uploadingFile(code: String, param: [String : MultipartFormData.FormDataProvider], completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .uploadingFile(code: code, param: param)) { (result) in
            if case .success(let data) = result {
                guard let imageMD = try? JSONDecoder().decode(LTImageModel.self, from: data) else {
                    completion(.failure(LTNetworking.YYError(errorCode: nil, message: "Data parsing failure".localString)))
                    return
                }
                self.updataImgs = imageMD.data
            }
            completion(result)
        }
    }
    /// 意见反馈
    func advise(param: [String : String], completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .advise(param: param)) { (result) in
            completion(result)
        }
    }
    /// 根据userID查询用户信息
    func userById(userId: String, completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .userById(userId: userId)) { (result) in
            if case .success(let data) = result {
                guard let model = try? JSONDecoder().decode(LTMyInfoModel.self, from: data) else {
                    LTHUD.show(type: .error, text: "Data parsing failure".localString)
                    return
                }
                var aUser = self.user
                aUser?.data.user = model.data
                guard let encoderData = try? JSONEncoder().encode(aUser) else { return }
                UserDefaults.standard.set(encoderData, forKey: USERMODELCACHE)
                UserDefaults.standard.synchronize()
            }
            completion(result)
        }
    }
}
