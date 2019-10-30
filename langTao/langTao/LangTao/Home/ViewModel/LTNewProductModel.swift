//
//  LTNewProductModel.swift
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
//  Created by LonTe on 2019/8/21.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

class LTNewProductModel: NSObject {
    var newModels: [LTHomeModel.ProductModel]?

    /// 根据创建时间查询最新产品列表
    func productCreatetime(completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .productCreatetime) { [weak self] (result) in
            guard let `self` = self else { return }
            if case .success(let data) = result {
                guard let model = try? JSONDecoder().decode(LTNewProModel.self, from: data) else {
                    completion(.failure(LTNetworking.YYError(errorCode: nil, message: "Data parsing failure".localString)))
                    return
                }
                self.newModels = model.data
            }
            completion(result)
        }
    }
}
