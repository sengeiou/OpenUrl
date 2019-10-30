//
//  LTFindPasswordViewController.swift
//  langTao
//
//  Created by LonTe on 2019/7/22.
//  Copyright © 2019 LangTe. All rights reserved.
//

import UIKit

class LTFindPasswordViewController: LTViewController {
    let source = ["Phone number".localString, "Verification Code".localString, "Enter new password".localString, "Enter new password again".localString, "Done".localString]
    var userNum = ""
    var codeNum = ""
    var password = ""
    var cheakPassword = ""
    lazy var codeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Get Code".localString, for: .normal)
        btn.setTitleColor(LTTheme.select, for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .disabled)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.addTarget(self, action: #selector(getCodeAction(_:)), for: .touchUpInside)
        return btn
    }()
    var timer: DispatchSourceTimer?
    var timeCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Forgot Password".localString
        // Do any additional setup after loading the view.
        let table = UITableView(frame: .zero, style: .plain)
        view.addSubview(table)
        table.backgroundColor = UIColor.white
        table.delegate = self
        table.dataSource = self
        table.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        table.separatorStyle = .none
        
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func inpuTextDidChang(_ inpu: UITextField) {
        switch inpu.placeholder {
        case "Phone number".localString:
            if let text = inpu.text, text.count > 11 {
                inpu.text = String(text.prefix(11))
            }
            userNum = inpu.text ?? ""
        case "Verification Code".localString:
            if let text = inpu.text, text.count > 6 {
                inpu.text = String(text.prefix(6))
            }
            codeNum = inpu.text ?? ""
        case "Enter new password".localString:
            if let text = inpu.text, text.count > 16 {
                inpu.text = String(text.prefix(16))
            }
            password = inpu.text ?? ""
        case "Enter new password again".localString:
            if let text = inpu.text, text.count > 16 {
                inpu.text = String(text.prefix(16))
            }
            cheakPassword = inpu.text ?? ""
        default:
            break
        }
    }
    
    @objc func getCodeAction(_ btn: UIButton) {
        if userNum.count == 0 {
            LTHUD.show(text: "Please enter your phone number".localString)
            return
        }
        btn.isEnabled = false
        LTUserViewModel.shared.getCode(sort: "2", mobile: userNum) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.timeDown()
                }
            case .failure:
                btn.isEnabled = true
            }
        }
    }
    
    func timeDown() {
        timeCount = 60
        codeBtn.setTitle("\(timeCount)s", for: .normal)
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer?.schedule(wallDeadline: .now()+1, repeating: .seconds(1), leeway: .milliseconds(1))
        timer?.setEventHandler(handler: { [weak self] in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.timeCount -= 1
                self.codeBtn.setTitle("\(self.timeCount)s", for: .normal)
                if self.timeCount == 0 {
                    self.timer?.cancel()
                    self.codeBtn.setTitle("Retrieve Code".localString, for: .normal)
                    self.codeBtn.isEnabled = true
                }
            }
        })
        timer?.resume()
    }
    
    @objc func buttonsAction(_ btn: UIButton) {
        view.endEditing(true)
        if userNum.count == 0 {
            LTHUD.show(text: "Please enter your phone number".localString)
            return
        }
        if codeNum.count == 0 {
            LTHUD.show(text: "Please enter the verification code".localString)
            return
        }
        if password.count == 0 {
            LTHUD.show(text: "Please input a new password".localString)
            return
        }
        if cheakPassword.count == 0 {
            LTHUD.show(text: "Please enter your new password again".localString)
            return
        }
        if password.count < 6 {
            LTHUD.show(text: "Password must not be less than 6 bits".localString)
            return
        }
        if password != cheakPassword {
            LTHUD.show(text: "Two inconsistent password input".localString)
            return
        }
        let param = ["mobile" : userNum, "password" : password]
        LTUserViewModel.shared.findPasswordAndModifyPhoto(code: codeNum, param: param) { [weak self] result in
            guard let `self` = self else { return }
            if case .success = result {            
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

extension LTFindPasswordViewController: UITableViewDelegate, UITableViewDataSource {
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
        inpuText.layer.borderColor = UIColor.lightGray.cgColor
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
        case "Phone number".localString:
            cell.contentView.addSubview(inpuText)
            inpuText.keyboardType = .numberPad
            inpuText.text = userNum
        case "Verification Code".localString:
            cell.contentView.addSubview(inpuText)
            inpuText.keyboardType = .numberPad
            inpuText.text = codeNum
            inpuText.frame.size.width = KEYSCREEN_W-insetX*2-120
            
            cell.contentView.addSubview(codeBtn)
            codeBtn.frame = CGRect(x: inpuText.frame.maxX+10, y: inpuText.frame.minY, width: KEYSCREEN_W-inpuText.frame.maxX-10-insetX, height: inpuText.frame.height)
        case "Enter new password".localString:
            cell.contentView.addSubview(inpuText)
            if #available(iOS 11.0, *) {
                inpuText.textContentType = .password
            }
            if #available(iOS 12.0, *) {
                inpuText.textContentType = .newPassword
            }
            inpuText.isSecureTextEntry = true
            inpuText.keyboardType = .alphabet
            inpuText.text = password
        case "Enter new password again".localString:
            cell.contentView.addSubview(inpuText)
            if #available(iOS 11.0, *) {
                inpuText.textContentType = .password
            }
            if #available(iOS 12.0, *) {
                inpuText.textContentType = .newPassword
            }
            inpuText.isSecureTextEntry = true
            inpuText.keyboardType = .alphabet
            inpuText.text = cheakPassword
        case "Done".localString:
            let logBtn = UIButton(type: .custom)
            logBtn.backgroundColor = LTTheme.select
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
        case "Done".localString:
            return 80
        default:
            return 65
        }
    }
}
