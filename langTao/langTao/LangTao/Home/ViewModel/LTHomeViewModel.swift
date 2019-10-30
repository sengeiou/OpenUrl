//
//  LTHomeViewModel.swift
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

class LTHomeViewModel: NSObject {
    var hotModels: [LTHomeModel.ProductModel]?
    var banners: [LTHomeModel.BannerModel]?
    var sorts: [LTSortModels.SortModel]?
    var bulletinBoard: LTHomeModel.BulletinBoardModel?
    
    /// 根据浏览量查询热门产品列表
    func productVisits(completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .productVisits) { [weak self] (result) in
            guard let `self` = self else { return }
            if case .success(let data) = result {
                guard let model = try? JSONDecoder().decode(LTHomeModel.self, from: data) else {
                    completion(.failure(LTNetworking.YYError(errorCode: nil, message: "Data parsing failure".localString)))
                    return
                }
                self.hotModels = model.data.commodity
                self.banners = model.data.ad_url
                self.bulletinBoard = model.data.BulletinBoard
            }
            completion(result)
        }
    }
    
    /// 分类全部列表
    func allSort(completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .allSort) { (result) in
            if case .success(let data) = result {
                guard let model = try? JSONDecoder().decode(LTSortModels.self, from: data) else {
                    completion(.failure(LTNetworking.YYError(errorCode: nil, message: "Data parsing failure".localString)))
                    return
                }
                self.sorts = model.data
                if self.sorts!.count > 0 {
                    let index = Int(arc4random()%UInt32(self.sorts!.count))
                    let sort = self.sorts![index]
                    UserDefaults.standard.set(sort.sort, forKey: SEARCHKEY)
                    UserDefaults.standard.synchronize()
                }
            }
            completion(result)
        }
    }
}
