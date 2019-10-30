//
//  LTReSetPasswordController.swift
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

class LTReSetPasswordController: LTViewController {
    let source = ["输入旧密码", "输入新密码", "再次输入新密码", "提   交"]
    var oldPassword = ""
    var newPassword = ""
    var againPassword = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "修改密码"
        
        let table = UITableView(frame: .zero, style: .plain)
        view.addSubview(table)
        table.backgroundColor = UIColor.white
        table.delegate = self
        table.dataSource = self
        table.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        table.separatorStyle = .none
        table.estimatedRowHeight = 0
        table.estimatedSectionHeaderHeight = 0
        table.estimatedSectionFooterHeight = 0
        
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func inpuTextDidChang(_ inpu: UITextField) {
        switch inpu.placeholder {
        case "输入旧密码":
            if let text = inpu.text, text.count > 16 {
                inpu.text = String(text.prefix(16))
            }
            oldPassword = inpu.text ?? ""
        case "输入新密码":
            if let text = inpu.text, text.count > 16 {
                inpu.text = String(text.prefix(16))
            }
            newPassword = inpu.text ?? ""
        case "再次输入新密码":
            if let text = inpu.text, text.count > 16 {
                inpu.text = String(text.prefix(16))
            }
            againPassword = inpu.text ?? ""
        default:
            break
        }
    }
    
    @objc func buttonsAction(_ btn: UIButton) {
        view.endEditing(true)
        if oldPassword.count == 0 {
            LTHUD.show(text: "请输入旧密码")
            return
        }
        if newPassword.count == 0 {
            LTHUD.show(text: "请输入新密码")
            return
        }
        if againPassword.count == 0 {
            LTHUD.show(text: "请再次输入新密码")
            return
        }
        if newPassword.count < 6 {
            LTHUD.show(text: "密码不能少于6位")
            return
        }
        if newPassword != againPassword {
            LTHUD.show(text: "两次密码输入不一致")
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

extension LTReSetPasswordController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.selectionStyle = .none
        let height = self.tableView(tableView, heightForRowAt: indexPath)
        if height < 1 { return cell }
        let insetX: CGFloat = 30
        let insetY: CGFloat = 15
        
        let inpuText = UITextField(frame: CGRect(x: insetX, y: insetY, width: KEYSCREEN_W-insetX*2, height: height-insetY))
        inpuText.borderStyle = .none
        inpuText.layer.borderColor = LTTheme.navBG.cgColor
        inpuText.layer.borderWidth = 1
        inpuText.layer.cornerRadius = 5
        inpuText.layer.masksToBounds = true
        inpuText.placeholder = source[indexPath.row]
        inpuText.font = UIFont.systemFont(ofSize: 15)
        inpuText.clearButtonMode = .whileEditing
        inpuText.autocorrectionType = .no
        inpuText.leftViewMode = .always
        inpuText.autocapitalizationType = .none
        inpuText.addTarget(self, action: #selector(inpuTextDidChang(_:)), for: .editingChanged)
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: height))
        inpuText.leftView = leftView
        
        switch source[indexPath.row] {
        case "输入旧密码":
            cell.contentView.addSubview(inpuText)
            inpuText.isSecureTextEntry = true
            inpuText.keyboardType = .alphabet
            inpuText.text = oldPassword
        case "输入新密码":
            cell.contentView.addSubview(inpuText)
            inpuText.isSecureTextEntry = true
            inpuText.keyboardType = .alphabet
            inpuText.text = newPassword
        case "再次输入新密码":
            cell.contentView.addSubview(inpuText)
            inpuText.isSecureTextEntry = true
            inpuText.keyboardType = .alphabet
            inpuText.text = againPassword
        case "提   交":
            let logBtn = UIButton(type: .custom)
            logBtn.backgroundColor = LTTheme.navBG
            logBtn.setTitle(source[indexPath.row], for: .normal)
            logBtn.setTitleColor(UIColor.white, for: .normal)
            logBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            logBtn.layer.cornerRadius = 5
            cell.contentView.addSubview(logBtn)
            logBtn.addTarget(self, action: #selector(buttonsAction(_:)), for: .touchUpInside)
            logBtn.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(UIEdgeInsets(top: insetY*2, left: insetX, bottom: 0, right: insetX))
            }
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch source[indexPath.row] {
        case "提   交":
            return 80
        default:
            return 65
        }
    }
}
