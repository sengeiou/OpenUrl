//
//  LTRuningCollectionViewCell.swift
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
//  Created by LonTe on 2019/10/9.
//  Copyright © 2019 LangTe. All rights reserved.
//


import UIKit

class LTRuningCollectionViewCell: UICollectionViewCell {
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
        let centerView = UIView()
        contentView.addSubview(centerView)
        
        let topView = UIView()
        centerView.addSubview(topView)
        
        image = UIImageView()
        topView.addSubview(image)
        
        title = UILabel()
        title.font = UIFont.systemFont(ofSize: 17)
        title.textColor = UIColor.gray
        topView.addSubview(title)
        
        subTitle = UILabel()
        subTitle.font = UIFont.boldSystemFont(ofSize: 18)
        subTitle.textColor = .darkGray
        centerView.addSubview(subTitle)
        
        image.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalTo(title)
            $0.size.equalTo(CGSize.zero)
        }
        
        title.snp.makeConstraints {
            $0.left.equalTo(image.snp.right)
            $0.top.right.bottom.equalToSuperview()
        }
        
        topView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        subTitle.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        centerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func upDateUI() {
        if let obj = itemObj {
            title.text = obj.title
            subTitle.text = obj.subTitle
            image.image = obj.image
            
            if obj.subTitle == "已连接" {
                subTitle.textColor = .green
            } else {
                subTitle.textColor = .darkGray
            }
            
            image.snp.updateConstraints {
                $0.size.equalTo(obj.image.size)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
