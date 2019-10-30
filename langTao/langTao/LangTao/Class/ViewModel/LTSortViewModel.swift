//
//  LTSortViewModel.swift
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

class LTSortViewModel: NSObject {
    var sorts: [LTClassModel.ClassModel]?
    var products: [LTHomeModel.ProductModel]?
    
    /// 查询二级分类
    func getSort(completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .allSort) { (result) in
            if case .success(let data) = result {
                guard let models = try? JSONDecoder().decode(LTClassModel.self, from: data) else {
                    completion(.failure(LTNetworking.YYError(errorCode: nil, message: "Data parsing failure".localString)))
                    return
                }
                self.sorts = models.data.map({ (model) -> LTClassModel.ClassModel in
                    return LTClassModel.ClassModel(name: model.sort, isSelect: false)
                })
                self.sorts!.sort(by: { (model1, model2) -> Bool in
                    let str1 = NSMutableString(string: model1.name) as CFMutableString
                    CFStringTransform(str1, nil, kCFStringTransformToLatin, false)
                    CFStringTransform(str1, nil, kCFStringTransformStripCombiningMarks, false)
                    let pinyin1 = str1 as String
                    
                    let str2 = NSMutableString(string: model2.name) as CFMutableString
                    CFStringTransform(str2, nil, kCFStringTransformToLatin, false)
                    CFStringTransform(str2, nil, kCFStringTransformStripCombiningMarks, false)
                    let pinyin2 = str2 as String
                    
                    return pinyin1.compare(pinyin2) == .orderedAscending
                })
                if self.sorts!.count > 0 {
                    self.sorts![0].isSelect = true
                }
            }
            completion(result)
        }
    }
    
    /// 根据条件查询产品列表列表
    func sortSearchByClass(className: String, completion: @escaping YYCompletion) {
        LTNetworking.loadData(API: LTAPI.self, target: .sortSearchByClass(className: className)) { (result) in
            if case .success(let data) = result {
                guard let models = try? JSONDecoder().decode(LTSearchModel.self, from: data) else {
                    completion(.failure(LTNetworking.YYError(errorCode: nil, message: "Data parsing failure".localString)))
                    return
                }
                self.products = models.data
            }
            completion(result)
        }
    }
}
