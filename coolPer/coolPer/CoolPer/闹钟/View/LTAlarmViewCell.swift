//
//  LTAlarmViewCell.swift
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

class LTAlarmViewCell: UITableViewCell {
    var switchOff: UISwitch!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addViews()
    }
    
    func addViews() {
        selectionStyle = .none
        textLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        textLabel?.textColor = .gray
        switchOff = UISwitch()
        switchOff.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        accessoryView = switchOff
    }
    
    @objc func switchChanged() {
        if switchOff.isOn {
            textLabel?.textColor = .black
        } else {
            textLabel?.textColor = .gray
        }
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
