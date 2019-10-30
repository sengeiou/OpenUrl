//
//  LTUploadCell.swift
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
//  Created by LonTe on 2019/9/4.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

class LTUploadCell: UICollectionViewCell {
    var imageView: UIImageView!
    private var button: UIButton!
    private var idx: Int?
    private var block: ((Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(image: IMGPLACEHOLDER)
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(deletaAction), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "删  除"), for: .normal)
        contentView.addSubview(button)
        
        button.snp.makeConstraints {
            $0.right.equalToSuperview().offset(8)
            $0.top.equalToSuperview().offset(-8)
        }
        
        layer.zPosition = 1
    }
    
    @objc private func deletaAction() {
        if let index = idx {
            block?(index)
        }
    }
    
    func deleteUploadModel(index: Int, complete: @escaping (Int)->()) {
        idx = index
        block = complete
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LTUploadCell: JXPhotoBrowserZoomTransitioningOriginResource {
    var originResourceView: UIView {
        return imageView
    }
    
    var originResourceAspectRatio: CGFloat {
        return 1
    }
}
