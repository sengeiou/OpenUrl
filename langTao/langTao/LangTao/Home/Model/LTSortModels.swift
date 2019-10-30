//
//  LTSortModels.swift
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
//  Created by LonTe on 2019/8/24.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

struct LTSortModels: Codable {
    var data: [SortModel]

    struct SortModel: Codable {
        var id: String
        var sort: String
        var parentId: String
        var isSelect: Bool?
    }
}
