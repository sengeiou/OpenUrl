//
//  LTSearchReusableView.swift
//  langTao
//
//  Created by LonTe on 2019/8/1.
//  Copyright © 2019 LonTe. All rights reserved.
//

import UIKit

class LTSearchReusableView: UICollectionReusableView {
    var msg: UILabel?
    var clearBtn: UIButton?
    private var block: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        msg = UILabel()
        msg?.font = UIFont.systemFont(ofSize: 15)
        msg?.textColor = UIColor.gray
        msg?.text = "Search history".localString
        addSubview(msg!)
        
        msg?.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        })
        
        clearBtn = UIButton(type: .custom)
        clearBtn?.setImage(#imageLiteral(resourceName: "waste"), for: .normal)
        clearBtn?.contentHorizontalAlignment = .right
        clearBtn?.addTarget(self, action: #selector(clearClick), for: .touchUpInside)
        addSubview(clearBtn!)
        
        clearBtn?.snp.makeConstraints({
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().inset(17)
            $0.width.equalTo(clearBtn!.snp.height)
        })
    }
    
    @objc private func clearClick() {
        block?()
    }
    
    func clearAction(_ call: @escaping (()->())) {
        block = call
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
