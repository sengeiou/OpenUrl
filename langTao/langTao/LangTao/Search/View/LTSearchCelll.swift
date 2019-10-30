//
//  LTSearchCelll.swift
//  langTao
//
//  Created by LonTe on 2019/8/1.
//  Copyright © 2019 LonTe. All rights reserved.
//

import UIKit

class LTSearchCelll: UICollectionViewCell {
    var label: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label = UILabel()
        label?.textAlignment = .center
        contentView.addSubview(label!)
        contentView.backgroundColor = UIColor.white
        contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        contentView.layer.borderWidth = 0.5
        
        label?.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(12)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
