//
//  LTRingCell.swift
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
//  Created by LonTe on 2019/10/14.
//  Copyright © 2019 LangTe. All rights reserved.
//


import UIKit

class LTRingCell: UITableViewCell {
    private var centerView: UIView!
    private var device: UIImageView!
    private var name: UILabel!
    private var status: UILabel!
    
    var cellData: LTRingManageController.RuningData? {
        didSet {
            updateUI()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addViews()
    }
    
    private func addViews() {
        centerView = UIView()
        centerView.layer.cornerRadius = 10
        centerView.layer.masksToBounds = true
        centerView.layer.backgroundColor = LTTheme.navBG.cgColor
        contentView.addSubview(centerView)
        
        centerView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(15)
            $0.top.bottom.equalToSuperview()
        }
        
        device = UIImageView(image: #imageLiteral(resourceName: "device_time"))
        device.contentMode = .scaleAspectFill
        device.clipsToBounds = true
        centerView.addSubview(device)
        
        device.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(15)
        }
        
        name = UILabel()
        name.textColor = .white
        name.font = UIFont.boldSystemFont(ofSize: 18)
        centerView.addSubview(name)
        
        name.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(device.snp.right).offset(15)
        }
        
        status = UILabel()
        status.textColor = .white
        centerView.addSubview(status)
        
        status.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(15)
        }
    }
    
    private func updateUI() {
        if let data = cellData {
            name.text = data.name
            status.text = data.status
            if status.text == "已连接" {
                status.font = UIFont.boldSystemFont(ofSize: 16)
            } else {
                status.font = UIFont.systemFont(ofSize: 16)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        centerView.layoutIfNeeded()
        device.layer.cornerRadius = device.frame.width/2
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
