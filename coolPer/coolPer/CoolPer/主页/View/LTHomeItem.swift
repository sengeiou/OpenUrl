//
//  LTHomeItem.swift
//  coolPer
//
//  Created by LonTe on 2019/7/10.
//  Copyright © 2019 LangTe. All rights reserved.
//

import UIKit

class LTHomeItem: UICollectionViewCell {
    var titleLabel: UILabel?
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        let font = UIFont.systemFont(ofSize: 13)
        
        imageView = UIImageView()
        imageView?.contentMode = .scaleAspectFit
        addSubview(imageView!)
        
        imageView?.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(snp.centerY).offset(-font.lineHeight/2)
            $0.width.height.equalTo(snp.height).multipliedBy(0.66)
        })
        
        titleLabel = UILabel()
        titleLabel?.font = font
        titleLabel?.textColor = UIColor.white
        addSubview(titleLabel!)
        
        titleLabel?.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView!.snp.bottom).offset(0)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
