//
//  LTSearchProductModel.swift
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

struct LTSearchProductModel: Codable {
    var data: SearchPageModel
    
    struct SearchPageModel: Codable {
        var total: Int
        var rows: [LTHomeModel.ProductModel]
    }
}
