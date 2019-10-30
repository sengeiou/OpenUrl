//
//  LTFactoryCell.swift
//  langTao
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
//  Created by LonTe on 2019/8/22.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

class LTFactoryCell: UITableViewCell {
    var num: UILabel!
    var logo: UIImageView!
    var name: UILabel!
    var address: UILabel!
    var isNum: Bool = true
    
    var numModel: LTNumSortModel.NumSortModel? {
        didSet {
            configNumData()
        }
    }
    
    var factoryModel: LTFactoryModel.FactoryModel? {
        didSet {
            configFactoryData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        separatorInset.left = 16
        selectionStyle = .none
        backgroundColor = UIColor.clear
        initSubViews()
    }
    
    func initSubViews() {
        num = UILabel()
        addSubview(num)
        num.textColor = UIColor.darkGray
        num.font = UIFont.systemFont(ofSize: 16)
        num.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(25)
        }
        
        logo = UIImageView()
        logo.image = #imageLiteral(resourceName: "placeholder")
        logo.contentMode = .scaleAspectFill
        logo.clipsToBounds = true
        addSubview(logo)
        
        logo.layer.cornerRadius = 25
        
        logo.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(50)
            $0.left.equalTo(num.snp.right)
        }
        
        name = UILabel()
        addSubview(name)
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.snp.makeConstraints {
            $0.left.equalTo(logo.snp.right).offset(8)
            $0.bottom.equalTo(logo.snp.centerY).inset(-5)
        }
        
        address = UILabel()
        addSubview(address)
        address.textColor = UIColor.darkGray
        address.font = UIFont.systemFont(ofSize: 13)
        address.snp.makeConstraints {
            $0.left.equalTo(name)
            $0.top.equalTo(name.snp.bottom).offset(5)
            $0.right.equalToSuperview().inset(15)
        }
    }
    
    func configNumData() {
        num.snp.updateConstraints {
            $0.width.equalTo(25)
        }
        
        guard let m = numModel else { return }
        num.text = "\(m.ranking)"
        logo.kf.setImage(with: m.logo.url, placeholder: #imageLiteral(resourceName: "placeholder"))
        name.text = m.name
        address.text = m.address
    }
    
    func configFactoryData() {
        num.snp.updateConstraints {
            $0.width.equalTo(0)
        }
        
        guard let m = factoryModel else { return }
        num.text = ""
        logo.kf.setImage(with: m.logo.url, placeholder: #imageLiteral(resourceName: "placeholder"))
        name.text = m.name
        address.text = m.address
    }
    
    required init?(coder aDecoder: NSCoder) {
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
