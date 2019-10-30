//
//  LTFactoryModel.swift
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

struct LTFactoryModel: Codable {
    var data: [FactoryModel]
    
    struct FactoryModel: Codable {
        var id: String
        var name: String
        var address: String
        var logo: String
        var summary: String
        var poster: String
        var mobile: String
        /// 1未审核 2审核 3广告
        var state: Int
        var sort: String?
        var permit: String?
    }
}
