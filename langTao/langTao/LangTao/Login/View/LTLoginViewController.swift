//
//  LTLoginViewController.swift
//  langTao
//
//  Created by LonTe on 2019/7/22.
//  Copyright © 2019 LangTe. All rights reserved.
//

import UIKit

class LTLoginViewController: LTViewController {
    let source = ["Phone number".localString, "Password".localString, "Sign in".localString, "Login".localString+"_"+"Forget Password".localString]
    var userNum = ""
    var password = ""
    var cache = true

    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .fullScreen
        
        let table = UITableView(frame: .zero, style: .plain)
        view.addSubview(table)
        table.backgroundColor = UIColor.white
        table.delegate = self
        table.dataSource = self
        table.contentInset = UIEdgeInsets(top: 260*KEYSCREEN_W/375, left: 0, bottom: 0, right: 0)
        table.separatorStyle = .none
        
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let image = #imageLiteral(resourceName: "bj")
        let rect = CGRect(x: 0, y: -table.contentInset.top, width: KEYSCREEN_W, height: KEYSCREEN_W*image.size.height/image.size.width)
        let layer = CALayer()
        layer.contents = image.cgImage
        layer.frame = rect
        table.layer.addSublayer(layer)
        layer.zPosition = 0
        
        let white = CALayer()
        white.backgroundColor = UIColor.white.cgColor
        let offX: CGFloat = 30
        white.frame = CGRect(x: offX, y: -20, width: KEYSCREEN_W-offX*2, height: 280)
        white.cornerRadius = 10
        white.borderWidth = 0.5
        white.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        white.shadowColor = LTTheme.select.cgColor
        white.shadowOffset = CGSize(width: 0, height: 3)
        white.shadowOpacity = 0.5
        white.masksToBounds = false
        table.layer.addSublayer(white)
        white.zPosition = 1
    }
    
    @objc func buttonsAction(_ btn: UIButton) {
        view.endEditing(true)
        switch btn.titleLabel?.text {
        case "Sign in".localString:
            if userNum.count == 0 {
                LTHUD.show(text: "Please enter your phone number".localString)
                return
            }
            if password.count == 0 {
                LTHUD.show(text: "Please input a password".localString)
                return
            }
            if password.count < 6 {
                LTHUD.show(text: "Password must not be less than 6 bits".localString)
                return
            }
            let param = ["mobile" : userNum, "password" : password]
            LTUserViewModel.shared.login(param: param) { [weak self] result in
                guard let `self` = self else { return }
                if case .success = result {                
                    LTHUD.show(text: "Login Successful".localString)
                    DispatchQueue.main.asyncAfter(wallDeadline: .now()+1.5, execute: {
                        self.navigationController?.dismiss(animated: true, completion: nil)
                    })
                }
            }
        case "Login".localString:
            navigationController?.pushViewController(LTRegisterViewController(), animated: true)
        case "Forget Password".localString:
            navigationController?.pushViewController(LTFindPasswordViewController(), animated: true)
        default:
            break
        }
    }
    
    @objc func inpuTextDidChang(_ inpu: UITextField) {
        switch inpu.placeholder {
        case "Phone number".localString:
            if let text = inpu.text, text.count > 11 {
                inpu.text = String(text.prefix(11))
            }
            cache = false
            userNum = inpu.text ?? ""
        case "Password".localString:
            if let text = inpu.text, text.count > 16 {
                inpu.text = String(text.prefix(16))
            }
            password = inpu.text ?? ""
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.barTintColor = LTTheme.select
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [.font : UIFont.boldSystemFont(ofSize: 20), .foregroundColor : UIColor.white]
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

extension LTLoginViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        cell.layer.zPosition = 2
        cell.selectionStyle = .none
        let height = self.tableView(tableView, heightForRowAt: indexPath)
        if height < 1 { return cell }
        let insetX: CGFloat = 60
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
        inpuText.leftViewMode = .always
        inpuText.autocorrectionType = .no
        inpuText.autocapitalizationType = .none
        inpuText.addTarget(self, action: #selector(inpuTextDidChang(_:)), for: .editingChanged)

        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: height-insetY, height: height-insetY))
        let leftImage = UIImageView()
        leftImage.contentMode = .center
        leftView.addSubview(leftImage)
        leftImage.frame = CGRect(x: 0, y: 0, width: height-30, height: height-30)
        leftImage.center = leftView.center
        inpuText.leftView = leftView

        switch source[indexPath.row] {
        case "Phone number".localString:
            cell.contentView.addSubview(inpuText)
            inpuText.keyboardType = .numberPad
            leftImage.image = #imageLiteral(resourceName: "user")
            if cache {
                userNum = UserDefaults.standard.string(forKey: USERMODELMODILE) ?? ""
            }
            inpuText.text = userNum
        case "Password".localString:
            cell.contentView.addSubview(inpuText)
            if #available(iOS 11.0, *) {
                inpuText.textContentType = .password
            }
            if #available(iOS 12.0, *) {
                inpuText.textContentType = .newPassword
            }
            inpuText.isSecureTextEntry = true
            inpuText.keyboardType = .alphabet
            leftImage.image = #imageLiteral(resourceName: "psword")
            inpuText.text = password
        case "Sign in".localString:
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
        case "Login".localString+"_"+"Forget Password".localString:
            let titles = source[indexPath.row].components(separatedBy: "_")
            let reger = UIButton(type: .custom)
            reger.setTitleColor(UIColor.lightGray, for: .normal)
            reger.setTitle(titles.first, for: .normal)
            reger.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.contentView.addSubview(reger)
            reger.addTarget(self, action: #selector(buttonsAction(_:)), for: .touchUpInside)
            reger.snp.makeConstraints {
                $0.left.equalToSuperview().inset(insetX)
                $0.top.equalToSuperview().inset(5)
            }
            
            let find = UIButton(type: .custom)
            find.setTitleColor(UIColor.lightGray, for: .normal)
            find.setTitle(titles.last, for: .normal)
            find.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.contentView.addSubview(find)
            find.addTarget(self, action: #selector(buttonsAction(_:)), for: .touchUpInside)
            find.snp.makeConstraints {
                $0.right.equalToSuperview().inset(insetX)
                $0.top.equalTo(reger)
            }
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch source[indexPath.row] {
        case "Sign in".localString:
            return 80
        default:
            return 65
        }
    }
}
