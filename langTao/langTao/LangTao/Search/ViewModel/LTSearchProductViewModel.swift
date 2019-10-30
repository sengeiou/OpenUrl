//
//  LTSearchProductViewModel.swift
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
//  Created by LonTe on 2019/8/26.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

class LTSearchProductViewModel {
    private var size = 10
    private var completion: YYCompletion!
    var loaded = false
    var searchKey = ""
    var products: [LTHomeModel.ProductModel]?
    
    init(size: Int = 10, completion: @escaping YYCompletion) {
        self.size = size
        self.completion = completion
    }
    
    func firstPage() {
        loaded = false
        gotoPage(page: 1)
    }
    
    func nextPage() {
        if let datas = products {
            gotoPage(page: datas.count/size+1)
        }
    }
    
    private func gotoPage(page: Int) {
        LTNetworking.loadData(API: LTAPI.self, target: .productSearchPage(page: page, size: size, param: ["productName" : searchKey])) { (result) in
            if case .success(let data) = result {
                guard let model = try? JSONDecoder().decode(LTSearchProductModel.self, from: data) else {
                    self.completion(.failure(LTNetworking.YYError(errorCode: nil, message: "Data parsing failure".localString)))
                    return
                }
                if page == 1 {
                    self.products = model.data.rows
                } else {
                    self.products = self.products!+model.data.rows
                }
                if model.data.rows.count < self.size {
                    self.loaded = true
                }
            }
            self.completion(result)
        }
    }
}
