//
//  LTDetailModel.swift
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

struct LTDetailModel: Codable {
    var data: DetailModel
    
    struct DetailModel: Codable {
        var enterprise: LTFactoryModel.FactoryModel
        var productList: [LTHomeModel.ProductModel]?
    }
}
