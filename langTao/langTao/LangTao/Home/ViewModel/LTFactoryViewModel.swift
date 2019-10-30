//
//  LTFactoryViewModel.swift
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
//  Created by LonTe on 2019/8/22.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

class LTFactoryViewModel: NSObject {
    var factorys: [LTFactoryModel.FactoryModel]?
    var sorts: [LTSortModels.SortModel]?
    var numFactorys: [LTNumSortModel.NumSortModel]?
    
    /// 根据商家分类查询商家排名列表 (sort 1 电子烟品牌， 2 供应商， 3 蓝牙产品...  子类产品传子类id)
    func enterpriseSort(sort: String, completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .enterpriseSort(sort: sort)) { (result) in
            if case .success(let data) = result {
                guard let model = try? JSONDecoder().decode(LTNumSortModel.self, from: data) else {
                    completion(.failure(LTNetworking.YYError(errorCode: nil, message: "Data parsing failure".localString)))
                    return
                }
                self.numFactorys = model.data
            }
            completion(result)
        }
    }
    
    /// 根据parentId查询分类
    func sortParentId(parentId: String, completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .sortParentId(parentId: parentId)) { (result) in
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
}
