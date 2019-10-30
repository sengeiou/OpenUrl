//
//  LTRunLineCell.swift
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
//  Created by LonTe on 2019/10/12.
//  Copyright © 2019 LangTe. All rights reserved.
//


import UIKit

class LTRunLineCell: UITableViewCell {
    var sort: UILabel!
    var icon: UIImageView!
    var name: UILabel!
    var stepNum: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
    }
    
    func addViews() {
        selectionStyle = .none
        
        sort = UILabel()
        sort.text = "00"
        sort.textAlignment = .right
        sort.font = UIFont.systemFont(ofSize: 18)
        sort.textColor = .darkGray
        contentView.addSubview(sort)
        let size = sort.sizeThatFits(.zero)
        
        sort.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(15)
            $0.size.equalTo(size)
        }
        
        icon = UIImageView(image: #imageLiteral(resourceName: "q_place"))
        icon.contentMode = .scaleAspectFill
        contentView.addSubview(icon)
        
        icon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(sort.snp.right).offset(10)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.width.equalTo(icon.snp.height)
        }
        
        name = UILabel()
        name.font = UIFont.systemFont(ofSize: 20)
        name.textColor = .darkGray
        contentView.addSubview(name)
        
        name.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(icon.snp.right).offset(10)
        }
        
        stepNum = UILabel()
        stepNum.font = UIFont.boldSystemFont(ofSize: 22)
        stepNum.textColor = RGB(82, 191, 162)
        contentView.addSubview(stepNum)
        
        stepNum.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(15)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        
        icon.layer.cornerRadius = icon.frame.width/2
        icon.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
