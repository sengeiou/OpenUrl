//
//  LTFirstClassCell.swift
//  langTao
//
//  Created by LonTe on 2019/8/2.
//  Copyright © 2019 LonTe. All rights reserved.
//

import UIKit

class LTFirstClassCell: UITableViewCell {
    var model: LTClassModel.ClassModel? {
        didSet {
            configData()
        }
    }
    var classLabel: UILabel?
    var selectView: UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = LTTheme.keyViewBG
        selectionStyle = .none

        classLabel = UILabel()
        classLabel?.font = UIFont.systemFont(ofSize: 14)
        classLabel?.textColor = UIColor.darkGray
        contentView.addSubview(classLabel!)
        classLabel?.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
        selectView = UILabel()
        selectView?.isHidden = true
        selectView?.backgroundColor = LTTheme.select
        contentView.addSubview(selectView!)
        selectView?.snp.makeConstraints({
            $0.top.bottom.left.equalToSuperview()
            $0.width.equalTo(5)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configData() {
        guard let mod = model else { return }
        classLabel?.text = mod.name
        if mod.isSelect {
            selectView?.isHidden = false
            classLabel?.textColor = LTTheme.select
            contentView.backgroundColor = UIColor.white
        } else {
            selectView?.isHidden = true
            classLabel?.textColor = UIColor.darkGray
            contentView.backgroundColor = LTTheme.keyViewBG
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
