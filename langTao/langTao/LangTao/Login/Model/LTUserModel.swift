//
//  LTUserModel.swift
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
//  Created by LonTe on 2019/8/12.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

struct LTUserModel: Codable {
    var data: UserModel
    struct UserModel: Codable {
        var user: User
        var token : String
        
        struct User: Codable {
            var id: String
            var mobile: String
            var nickname: String?
            var avatar: String?
            var eid: String?
            var roles: String  // 1 user   2 商户   3 admin
        }
    }
}

struct LTImageModel: Codable {
    var data: [String]
}

