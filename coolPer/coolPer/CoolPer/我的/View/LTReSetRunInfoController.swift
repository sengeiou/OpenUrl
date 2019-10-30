//
//  LTReSetRunInfoController.swift
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

class LTReSetRunInfoController: LTViewController {
    let source = ["身高", "体重", "每日目标", "更   改"]
    var tall = ""
    var weight = ""
    var walk = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "更改运动目标"
        
        let table = UITableView(frame: .zero, style: .plain)
        view.addSubview(table)
        table.backgroundColor = UIColor.white
        table.delegate = self
        table.dataSource = self
        table.separatorInset = UIEdgeInsets(top: 0, left: KEYSCREEN_W, bottom: 0, right: 0)
        table.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func inpuTextDidChang(_ inpu: UITextField) {
        switch inpu.placeholder {
        case "请填写身高":
            tall = inpu.text ?? ""
        case "请填写体重":
            weight = inpu.text ?? ""
        case "请填写每日目标":
            walk = inpu.text ?? ""
        default:
            break
        }
    }
    
    @objc func buttonsAction(_ btn: UIButton) {
        view.endEditing(true)
        
        if tall.count == 0 {
            LTHUD.show(text: "请填写身高")
            return
        }
        if weight.count == 0 {
            LTHUD.show(text: "请填写体重")
            return
        }
        if walk.count == 0 {
            LTHUD.show(text: "请填写每日目标")
            return
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LTReSetRunInfoController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        let height = self.tableView(tableView, heightForRowAt: indexPath)
        if height < 1 { return cell }
        let insetX: CGFloat = 20
        let insetY: CGFloat = 10
        
        let inpuText = UITextField(frame: CGRect(x: insetX, y: insetY, width: KEYSCREEN_W-insetX*2, height: height-insetY))
        inpuText.borderStyle = .none
        inpuText.font = UIFont.systemFont(ofSize: 15)
        inpuText.clearButtonMode = .whileEditing
        inpuText.leftViewMode = .always
        inpuText.rightViewMode = .always
        inpuText.textAlignment = .right
        inpuText.addTarget(self, action: #selector(inpuTextDidChang(_:)), for: .editingChanged)
        
        let leftText = UILabel()
        leftText.font = inpuText.font
        leftText.textColor = UIColor.darkGray
        leftText.text = source[indexPath.row]
        leftText.sizeToFit()
        leftText.frame.size.width += 15
        inpuText.leftView = leftText
        
        let rightView = UILabel()
        rightView.font = inpuText.font
        rightView.textColor = leftText.textColor
        rightView.textAlignment = .right
        
        switch source[indexPath.row] {
        case "身高":
            cell.contentView.addSubview(inpuText)
            inpuText.keyboardType = .numberPad
            inpuText.placeholder = "请填写身高"
            inpuText.text = tall
            
            rightView.text = "cm"
            rightView.sizeToFit()
            rightView.frame.size.width += 5
            inpuText.rightView = rightView
        case "体重":
            cell.contentView.addSubview(inpuText)
            inpuText.keyboardType = .numberPad
            inpuText.placeholder = "请填写体重"
            inpuText.text = weight
            
            rightView.text = "kg"
            rightView.sizeToFit()
            rightView.frame.size.width += 5
            inpuText.rightView = rightView
        case "每日目标":
            cell.contentView.addSubview(inpuText)
            inpuText.keyboardType = .numberPad
            inpuText.placeholder = "请填写每日目标"
            inpuText.text = walk
            
            rightView.text = "步"
            rightView.sizeToFit()
            rightView.frame.size.width += 5
            inpuText.rightView = rightView
        case "更   改":
            let logBtn = UIButton(type: .custom)
            logBtn.backgroundColor = LTTheme.navBG
            logBtn.setTitle(source[indexPath.row], for: .normal)
            logBtn.setTitleColor(UIColor.white, for: .normal)
            logBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            logBtn.layer.cornerRadius = 5
            cell.contentView.addSubview(logBtn)
            logBtn.addTarget(self, action: #selector(buttonsAction(_:)), for: .touchUpInside)
            logBtn.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(UIEdgeInsets(top: insetY*3, left: insetX, bottom: 0, right: insetX))
            }
            cell.separatorInset = UIEdgeInsets(top: 0, left: KEYSCREEN_W, bottom: 0, right: 0)
        default:
            break
        }
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch source[indexPath.row] {
        case "更   改":
            return 80
        default:
            return 60
        }
    }
}
