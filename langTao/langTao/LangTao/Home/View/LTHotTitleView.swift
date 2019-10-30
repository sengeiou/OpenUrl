//
//  LTHotTitleView.swift
//  langTao
//
//  Created by LonTe on 2019/7/30.
//  Copyright © 2019 LonTe. All rights reserved.
//

import UIKit

class LTHotTitleView: UICollectionReusableView {
    var label: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label = UILabel()
        label?.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(label!)
        
        label?.snp.makeConstraints({
            $0.left.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
