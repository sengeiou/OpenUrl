
//
//  LTSecondCell.swift
//  langTao
//
//  Created by LonTe on 2019/8/2.
//  Copyright © 2019 LonTe. All rights reserved.
//

import UIKit

class LTSecondCell: UICollectionViewCell {
    var imageView: UIImageView?
    var titleLabel: UILabel?
    
    var model: LTHomeModel.ProductModel? {
        didSet {
            configData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        imageView?.contentMode = .scaleAspectFill
        imageView?.clipsToBounds = true
        contentView.addSubview(imageView!)
        
        titleLabel = UILabel()
        titleLabel?.font = UIFont.systemFont(ofSize: 12)
        titleLabel?.textColor = UIColor.darkGray
        titleLabel?.numberOfLines = 2
        contentView.addSubview(titleLabel!)
        
        imageView?.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.width.equalTo(imageView!.snp.height)
        })
        
        titleLabel?.snp.makeConstraints({
            $0.left.right.equalTo(imageView!)
            $0.top.equalTo(imageView!.snp.bottom).offset(5)
        })
    }
    
    func configData() {        
        guard let m = model else {
            imageView?.image = IMGPLACEHOLDER
            titleLabel?.text = ""
            return
        }
        
        imageView?.kf.setImage(with: (m.picture ?? "").url, placeholder: IMGPLACEHOLDER)
        titleLabel?.text = m.productName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
