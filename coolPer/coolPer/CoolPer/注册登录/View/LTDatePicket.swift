//
//  LTDatePicket.swift
//  coolPer
//
//  Created by LonTe on 2019/7/22.
//  Copyright © 2019 LangTe. All rights reserved.
//

import UIKit
import YYFast

class LTDatePicket: UIControl {
    var selecData: Date {
        get {
            return _currectDate
        }
        set {
            _currectDate = newValue
            datePicker?.date = newValue
        }
    }
    private let barHeight: CGFloat = 45
    private var block: ((Date)->())?
    private var _currectDate: Date = Date()
    private var datePicker: UIDatePicker?
    private var bgView: UIView?
    
    init(frame: CGRect, selectDate: @escaping (Date)->()) {
        super.init(frame: frame)
        block = selectDate
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
        configUI()
    }
    
    private func configUI() {
        bgView = UIView()
        bgView?.backgroundColor = UIColor.white
        addSubview(bgView!)
        
        datePicker = UIDatePicker(frame: CGRect.zero)
        datePicker?.datePickerMode = .date
        bgView?.addSubview(datePicker!)
        datePicker?.sizeToFit()
        datePicker?.frame.size.width = frame.width
        datePicker?.frame.origin.y = barHeight
        datePicker?.maximumDate = Date()
        datePicker?.setValue(UIColor.black, forKeyPath: "textColor")
        
        bgView?.frame = CGRect(x: 0, y: frame.height-datePicker!.frame.height-barHeight, width: frame.width, height: datePicker!.frame.height+barHeight)
        for view in datePicker!.subviews {
            if "\(view.classForCoder)" == "_UIDatePickerView" {
                for sub in view.subviews {
                    if sub.frame.height < 1 {
                        sub.backgroundColor = UIColor(white: 0, alpha: 0.8)
                    }
                }
            }
        }
        
        let cancel = UIButton(type: .custom)
        bgView?.addSubview(cancel)
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(UIColor.black, for: .normal)
        cancel.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancel.addTarget(self, action: #selector(dismiss), for: .touchUpInside)

        cancel.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.width.equalTo(70)
            $0.height.equalTo(barHeight)
        }
        
        let sure = UIButton(type: .custom)
        bgView?.addSubview(sure)
        sure.setTitle("确定", for: .normal)
        sure.setTitleColor(UIColor.black, for: .normal)
        sure.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sure.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        
        sure.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.width.equalTo(70)
            $0.height.equalTo(barHeight)
        }
    }
    
    @objc private func sureAction() {
        block?(datePicker!.date)
        dismiss()
    }
    
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView?.frame.origin.y = self.frame.height
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        bgView?.frame.origin.y = frame.height
        UIView.animate(withDuration: 0.3) {
            self.bgView?.frame.origin.y = self.frame.height-self.datePicker!.frame.height-self.barHeight
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
