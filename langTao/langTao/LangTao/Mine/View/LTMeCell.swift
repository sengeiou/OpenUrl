//
//  LTMeCell.swift
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
//  Created by LonTe on 2019/8/28.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

class LTMeCell: UICollectionViewCell {
    var model: LTIconModel? {
        didSet {
            configData()
        }
    }
    var imageView: UIImageView!
    var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
        
        let content = UIView()
        contentView.addSubview(content)
        
        imageView = UIImageView()
        content.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        title = UILabel()
        title.font = UIFont.systemFont(ofSize: 14)
        content.addSubview(title)
        
        title.snp.makeConstraints {
            $0.centerX.equalTo(imageView)
            $0.bottom.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(10)
        }
        
        content.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(imageView)
            $0.bottom.equalTo(title)
            $0.center.equalToSuperview()
        }
    }
    
    func configData() {
        if let m = model {
            imageView.image = m.image
            title.text = m.title
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
