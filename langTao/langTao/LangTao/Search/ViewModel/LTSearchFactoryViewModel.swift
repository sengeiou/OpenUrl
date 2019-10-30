//
//  LTSearchFactoryViewModel.swift
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

class LTSearchFactoryViewModel {
    private var size = 10
    private var completion: YYCompletion!
    var loaded = false
    var searchKey = ""
    var factorys: [LTFactoryModel.FactoryModel]?
    
    init(size: Int = 10, completion: @escaping YYCompletion) {
        self.size = size
        self.completion = completion
    }
    
    func firstPage() {
        loaded = false
        gotoPage(page: 1)
    }
    
    func nextPage() {
        if let datas = factorys {
            gotoPage(page: datas.count/size+1)
        }
    }
    
    private func gotoPage(page: Int) {
        LTNetworking.loadData(API: LTAPI.self, target: .enterpriseSearchPage(page: page, size: size, param: ["summary" : searchKey])) { (result) in
            if case .success(let data) = result {
                guard let model = try? JSONDecoder().decode(LTSearchFactoryModel.self, from: data) else {
                    self.completion(.failure(LTNetworking.YYError(errorCode: nil, message: "Data parsing failure".localString)))
                    return
                }
                if page == 1 {
                    self.factorys = model.data.rows
                } else {
                    self.factorys = self.factorys!+model.data.rows
                }
                if model.data.rows.count < self.size {
                    self.loaded = true
                }
            }
            self.completion(result)
        }
    }
}
