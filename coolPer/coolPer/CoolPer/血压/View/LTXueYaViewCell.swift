//
//  LTXueYaViewCell.swift
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
//  Created by LonTe on 2019/10/11.
//  Copyright © 2019 LangTe. All rights reserved.
//


import UIKit

class LTXueYaViewCell: UICollectionViewCell {
    private var title: UILabel!
    var value: String? {
        didSet {
            upDateUI()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    private func addViews() {
        title = UILabel()
        contentView.addSubview(title)
        
        title.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        let line = UILabel()
        contentView.addSubview(line)
        line.backgroundColor = .lightGray
        
        line.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    private func upDateUI() {
        title.font = UIFont.systemFont(ofSize: 14)
        if let v = value {
            if v == "时间" || v == "高压" || v == "低压" || v == "压差" {
                title.font = UIFont.boldSystemFont(ofSize: 19)
            }
        }
        title.text = value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
