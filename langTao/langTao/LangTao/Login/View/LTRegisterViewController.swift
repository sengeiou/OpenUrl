//
//  LTRegisterViewController.swift
//  langTao
//
//  Created by LonTe on 2019/7/10.
//  Copyright © 2019 LangTe. All rights reserved.
//

import UIKit

class LTRegisterViewController: LTViewController {
    let source = ["Phone number".localString, "Verification Code".localString, "Enter password".localString, "Enter password again".localString, "Done".localString]
    var userNum = ""
    var codeNum = ""
    var password = ""
    var cheakPassword = ""
    var isSel = true
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
    var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "LoginT".localString
        // Do any additional setup after loading the view.
        table = UITableView(frame: .zero, style: .plain)
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
        case "Enter password".localString:
            if let text = inpu.text, text.count > 16 {
                inpu.text = String(text.prefix(16))
            }
            password = inpu.text ?? ""
        case "Enter password again".localString:
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
        LTUserViewModel.shared.getCode(sort: "1", mobile: userNum) { [weak self] result in
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
            LTHUD.show(text: "Please input a password".localString)
            return
        }
        if cheakPassword.count == 0 {
            LTHUD.show(text: "Please enter your password again".localString)
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
        if !isSel {
            LTHUD.show(text: "Please agree to the User Privacy Policy Agreement".localString)
            return
        }
        let nickName = String(userNum.suffix(6))
        let param = ["mobile" : userNum, "password" : password, "nickname" : "User".localString+nickName]
        LTUserViewModel.shared.register(code: codeNum, param: param) { [weak self] result in
            if case .success = result {
                LTUserViewModel.shared.login(param: param, completion: { result in
                    guard let `self` = self else { return }
                    if case .success = result {                    
                        LTHUD.show(text: "Login Successful".localString)
                        DispatchQueue.main.asyncAfter(wallDeadline: .now()+1.5, execute: {
                            self.navigationController?.dismiss(animated: true, completion: nil)
                        })
                    }
                })
            }
        }
    }
    
    @objc func selAction() {
        isSel = !isSel
        table.reloadData()
    }
    
    @objc func goToUserAgreement() {
        navigationController?.pushViewController(LTUserAgreementController(), animated: true)
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

extension LTRegisterViewController: UITableViewDelegate, UITableViewDataSource {
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
        case "Enter password".localString:
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
        case "Enter password again".localString:
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
            inpuText.frame.size.height = 50
            
            let selImage = UIImageView(image: #imageLiteral(resourceName: "nomel"))
            selImage.frame.size = selImage.image!.size
            selImage.frame.origin.x = inpuText.frame.minX
            selImage.frame.origin.y = inpuText.frame.maxY+10
            cell.contentView.addSubview(selImage)
            if isSel {
                selImage.image = #imageLiteral(resourceName: "nomel")
            } else {
                selImage.image = #imageLiteral(resourceName: "select")
            }
            
            let text1 = UILabel()
            text1.text = "Registration means consent".localString
            text1.font = UIFont.systemFont(ofSize: 14)
            cell.contentView.addSubview(text1)
            text1.sizeToFit()
            text1.center.y = selImage.center.y
            text1.frame.origin.x = selImage.frame.maxX+5
            
            let text2 = UILabel()
            text2.text = "User Privacy Policy Agreement".localString
            text2.font = UIFont.systemFont(ofSize: 14)
            text2.textColor = LTTheme.select
            cell.contentView.addSubview(text2)
            text2.sizeToFit()
            text2.center.y = selImage.center.y
            text2.frame.origin.x = text1.frame.maxX
            text2.isUserInteractionEnabled = true
            
            let sel = UIView(frame: CGRect(x: selImage.frame.minX-10, y: selImage.frame.minY-10, width: selImage.frame.width+20, height: selImage.frame.height+20))
            cell.contentView.addSubview(sel)
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(selAction))
            sel.addGestureRecognizer(tap1)
            
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(goToUserAgreement))
            text2.addGestureRecognizer(tap2)
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
        case "Enter password again".localString:
            return 105
        default:
            return 65
        }
    }
}
