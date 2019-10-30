//
//  LTUploadModel.swift
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
//  Created by LonTe on 2019/9/3.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

struct LTUploadModel {
    enum ModelType {
        case image
        case video
    }
    
    init(image: UIImage?, imageUrl: String?, code: String) {
        self.image = image
        self.imageUrl = imageUrl
        self.code = code
        self.type = .image
    }
    
    init(fileUrl: URL?, videoUrl: String?, code: String) {
        self.fileUrl = fileUrl
        self.videoUrl = videoUrl
        self.code = code
        self.type = .video
    }
    
    let type: ModelType
    var image: UIImage?
    var imageUrl: String?
    var fileUrl: URL?
    var videoUrl: String?
    let code: String
}
