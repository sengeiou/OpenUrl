//
//  LTHomeModel.swift
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

struct LTHomeModel: Codable {
    var data: HomeModel
    
    struct HomeModel: Codable {
        var commodity: [ProductModel]
        var ad_url: [BannerModel]
        var BulletinBoard: BulletinBoardModel
    }
    
    struct ProductModel: Codable {
        var id: String
        var eid: String?
        var productName: String?
        var sort: String?
        var picture: String?
        var video: String?
        var ename: String?
        var material: String?
        var image: String?
        var state: Int
    }
    
    struct BannerModel: Codable {
        var id: Int
        var url: String
        var state: Int
        var eid: String
    }
    
    struct BulletinBoardModel: Codable {
        var id: Int
        var bulletinboard1: String
        var bulletinboard2: String
        var bulletinboard3: String
        var bulletinboard4: String
        var state: String
    }
}
