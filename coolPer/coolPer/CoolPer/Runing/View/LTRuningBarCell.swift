//
//  LTRuningBarCell.swift
//  coolPer
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
//  Created by LonTe on 2019/10/10.
//  Copyright © 2019 LangTe. All rights reserved.
//


import UIKit

class LTRuningBarCell: UICollectionViewCell {
    struct ItemObject {
        var title: String
        var subTitle: String
        var image: UIImage
    }
    private var image: UIImageView!
    private var title: UILabel!
    private var subTitle: UILabel!
    var itemObj: ItemObject? {
        didSet {
            upDateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    private func addViews() {
        image = UIImageView()
        contentView.addSubview(image)
        
        title = UILabel()
        title.font = UIFont.systemFont(ofSize: 18)
        title.textColor = UIColor.gray
        contentView.addSubview(title)
        
        subTitle = UILabel()
        subTitle.font = UIFont.boldSystemFont(ofSize: 17)
        subTitle.textColor = .darkGray
        contentView.addSubview(subTitle)
        
        image.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        title.snp.makeConstraints {
            $0.left.equalTo(image.snp.right).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        subTitle.snp.makeConstraints {
            $0.left.equalTo(title.snp.right).offset(15)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func upDateUI() {
        if let obj = itemObj {
            title.text = obj.title
            subTitle.text = obj.subTitle
            image.image = obj.image
        }
    }
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}
