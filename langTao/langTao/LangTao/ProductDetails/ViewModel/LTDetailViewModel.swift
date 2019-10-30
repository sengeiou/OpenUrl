//
//  LTDetailViewModel.swift
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
//  Created by LonTe on 2019/8/27.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

class LTDetailViewModel: NSObject {
    var detailModel: LTDetailModel.DetailModel?
    
    /// 根据商家id查询商家信息
    func enterpriseById(id: String, completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .enterpriseById(id: id)) { (result) in
            if case .success(let data) = result {
                guard var model = try? JSONDecoder().decode(LTDetailModel.self, from: data) else {
                    completion(.failure(LTNetworking.YYError(errorCode: nil, message: "Data parsing failure".localString)))
                    return
                }
                let products = model.data.productList!.filter({ (model) -> Bool in
                    return model.state == 2
                })
                model.data.productList = products
                self.detailModel = model.data
            }
            completion(result)
        }
    }
}
