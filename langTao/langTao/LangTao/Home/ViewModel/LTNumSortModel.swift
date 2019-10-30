//
//  LTNumSortModel.swift
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
//  Created by LonTe on 2019/10/6.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

struct LTNumSortModel: Codable {
    var data: [NumSortModel]
    
    struct NumSortModel: Codable {
        var ranking: Int
        var name: String
        var eid: String
        var address: String
        var logo: String
    }
}
