//
//  LTHomeTopItemCell.swift
//  langTao
//
//  Created by LonTe on 2019/7/30.
//  Copyright © 2019 LonTe. All rights reserved.
//

import UIKit

class LTHomeTopItemCell: UICollectionViewCell {
    var imageView: UIImageView?
    var label: UILabel?
    private let whiteView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(whiteView)
        whiteView.backgroundColor = UIColor.white
        whiteView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(-1)
        }
        
        contentView.backgroundColor = UIColor.white
        imageView = UIImageView()
        imageView?.contentMode = .scaleAspectFit
        contentView.addSubview(imageView!)
        
        label = UILabel()
        label?.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(label!)
        
        label?.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(5)
            $0.height.equalTo(label!.font.lineHeight)
        })
        
        imageView?.snp.makeConstraints({
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(label!.snp.top)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
