//
//  LTHotItemCell.swift
//  langTao
//
//  Created by LonTe on 2019/7/31.
//  Copyright © 2019 LonTe. All rights reserved.
//

import UIKit

class LTHotItemCell: UICollectionViewCell {
    private var imageView: UIImageView?
    private var transView: UIView?
    private var cheak: UILabel?
    private var name: UILabel?
    private var material: UILabel?
    private var ename: UILabel?
    var model: LTHomeModel.ProductModel? {
        didSet {
            configData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.white
        clipsToBounds = true
        imageView = UIImageView()
        imageView?.contentMode = .scaleAspectFill
        imageView?.clipsToBounds = true
        contentView.addSubview(imageView!)
        
        imageView?.snp.makeConstraints({
            $0.top.left.right.equalToSuperview()
            $0.width.equalTo(imageView!.snp.height)
        })
        
        transView = UIView()
        transView?.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        contentView.addSubview(transView!)
        
        transView?.snp.makeConstraints({
            $0.edges.equalTo(imageView!)
        })
        
        name = UILabel()
        name?.font = UIFont.systemFont(ofSize: 13)
        name?.textColor = UIColor.darkGray
        name?.numberOfLines = 2
        contentView.addSubview(name!)
        
        name?.snp.makeConstraints({
            $0.left.right.equalToSuperview().inset(8)
            $0.top.equalTo(imageView!.snp.bottom).offset(5)
        })
        
        material = UILabel()
        material?.font = UIFont.systemFont(ofSize: 12)
        material?.textColor = UIColor.gray
        contentView.addSubview(material!)
        
        material?.snp.makeConstraints({
            $0.left.right.equalTo(name!)
            $0.top.equalTo(name!.snp.bottom).offset(0)
        })
        
        ename = UILabel()
        ename?.font = UIFont.boldSystemFont(ofSize: 14)
        ename?.textColor = LTTheme.select
        contentView.addSubview(ename!)

        ename?.snp.makeConstraints({
            $0.bottom.equalToSuperview().inset(5)
            $0.left.right.equalTo(name!)
        })
        
        cheak = UILabel()
        cheak?.font = UIFont.systemFont(ofSize: 12)
        cheak?.textColor = UIColor.white
        cheak?.text = "In Audit".localString
        contentView.addSubview(cheak!)
        
        cheak?.snp.makeConstraints({
            $0.bottom.right.equalTo(imageView!).inset(5)
        })
    }
    
    func configData() {
        contentView.superview?.layoutIfNeeded()
        
        guard let m = model else { return }
        imageView?.kf.setImage(with: (m.picture ?? "").url, placeholder: IMGPLACEHOLDER)
        name?.text = m.productName
        let size = name!.sizeThatFits(CGSize(width: contentView.frame.width-16, height: CGFloat.greatestFiniteMagnitude))
        let lineNum = Int(size.height/name!.font.lineHeight)
        if lineNum > 1 {
            material?.isHidden = true
        } else {
            material?.isHidden = false
        }
        material?.text = "材质："+(m.material ?? "暂无")
        ename?.text = m.ename
        cheak?.isHidden = m.state == 1 ? false : true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
