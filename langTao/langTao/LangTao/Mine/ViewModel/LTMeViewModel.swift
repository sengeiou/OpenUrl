//
//  LTMeViewModel.swift
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
//  Created by LonTe on 2019/8/29.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

class LTMeViewModel: NSObject {
    var sorts: [LTSortModels.SortModel]?
    var sort: LTSortModels.SortModel?
    var detailModel: LTDetailModel.DetailModel?
    
    /// 根据商家id查询商家信息
    func enterpriseById(id: String, completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .enterpriseById(id: id)) { (result) in
            if case .success(let data) = result {
                guard let model = try? JSONDecoder().decode(LTDetailModel.self, from: data) else {
                    completion(.failure(LTNetworking.YYError(errorCode: nil, message: "Data parsing failure".localString)))
                    return
                }
                self.detailModel = model.data
            }
            completion(result)
        }
    }

    /// 查询分类
    func allSort(completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .allSort) { (result) in
            if case .success(let data) = result {
                guard let model = try? JSONDecoder().decode(LTSortModels.self, from: data) else {
                    completion(.failure(LTNetworking.YYError(errorCode: nil, message: "Data parsing failure".localString)))
                    return
                }
                self.sorts = model.data.map({ (model) -> LTSortModels.SortModel in
                    var m = model
                    m.isSelect = false
                    return m
                })
            }
            completion(result)
        }
    }
    
    /// 增加商家
    func addEnterprise(param: [String : String], completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .addEnterprise(param: param)) { (result) in
            completion(result)
        }
    }
    /// 修改商家
    func modifEnteriseById(id: String, param: [String : String], completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .modifEnteriseById(id: id, param: param)) { (result) in
            completion(result)
        }
    }
    /// 根据批量查询分类
    func sortByIds(sortIds: String, completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .sortByIds(sortIds: sortIds)) { (result) in
            if case .success(let data) = result {
                guard let model = try? JSONDecoder().decode(LTSortModels.self, from: data) else {
                    completion(.failure(LTNetworking.YYError(errorCode: nil, message: "Data parsing failure".localString)))
                    return
                }
                self.sorts = model.data
            }
            completion(result)
        }
    }
    /// 根据ID查询分类（并查询产品信息）
    func sortById(sortId: String, completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .sortById(sortId: sortId)) { (result) in
            if case .success(let data) = result {
                guard let model = try? JSONDecoder().decode(LTSortModel.self, from: data) else {
                    completion(.failure(LTNetworking.YYError(errorCode: nil, message: "Data parsing failure".localString)))
                    return
                }
                self.sort = model.data
            }
            completion(result)
        }
    }
    /// 增加产品
    func addProduct(param: [String : String], completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .addProduct(param: param)) { (result) in
            completion(result)
        }
    }
    /// 修改产品
    func modifProductById(productId: String, param: [String : String], completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .modifProductById(productId: productId, param: param)) { (result) in
            completion(result)
        }
    }
    /// 根据ID删除产品
    func deleteProductById(productId: String, completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .deleteProductById(productId: productId)) { (result) in
            completion(result)
        }
    }
}
