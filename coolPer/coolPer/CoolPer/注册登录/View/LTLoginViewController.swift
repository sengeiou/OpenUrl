//
//  LTLoginViewController.swift
//  coolPer
//
//  Created by LonTe on 2019/7/22.
//  Copyright © 2019 LangTe. All rights reserved.
//

import UIKit
import YYFast

class LTLoginViewController: LTViewController {
    let source = ["icon", "手机号码", "密码", "登   录", "注册新用户or忘记密码"]
    var userNum = ""
    var password = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let table = UITableView(frame: .zero, style: .plain)
        view.addSubview(table)
        table.backgroundColor = UIColor.white
        table.delegate = self
        table.dataSource = self
        table.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        table.separatorStyle = .none
        table.estimatedRowHeight = 0
        table.estimatedSectionHeaderHeight = 0
        table.estimatedSectionFooterHeight = 0
        
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func buttonsAction(_ btn: UIButton) {
        view.endEditing(true)
        switch btn.titleLabel?.text {
        case "登   录":
            if userNum.count == 0 {
                LTHUD.show(text: "请输入手机号")
                return
            }
            if password.count == 0 {
                LTHUD.show(text: "请输入密码")
                return
            }
            if password.count < 6 {
                LTHUD.show(text: "密码不能少于6位")
                return
            }
            LTHUD.show(text: "登录成功")
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        case "注册新用户":
            navigationController?.pushViewController(LTRegisterViewController(), animated: true)
        case "忘记密码":
            navigationController?.pushViewController(LTFindPasswordViewController(), animated: true)
        default:
            break
        }
    }
    
    @objc func inpuTextDidChang(_ inpu: UITextField) {
        switch inpu.placeholder {
        case "手机号码":
            if let text = inpu.text, text.count > 11 {
                inpu.text = String(text.prefix(11))
            }
            userNum = inpu.text ?? ""
        case "密码":
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
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
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

extension LTLoginViewController: UITableViewDelegate, UITableViewDataSource {
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
        inpuText.leftViewMode = .always
        inpuText.autocorrectionType = .no
        inpuText.autocapitalizationType = .none
        inpuText.addTarget(self, action: #selector(inpuTextDidChang(_:)), for: .editingChanged)
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: height-15, height: inpuText.frame.height))
        let leftImage = UIImageView()
        leftImage.contentMode = .scaleAspectFit
        leftView.addSubview(leftImage)
        leftImage.frame.size.width = height-30
        leftImage.frame.size.height = leftImage.frame.width
        leftImage.center = CGPoint(x: leftView.bounds.width/2, y: leftView.bounds.height/2)
        inpuText.leftView = leftView

        switch source[indexPath.row] {
        case "icon":
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            cell.contentView.addSubview(imageView)
            imageView.image = #imageLiteral(resourceName: "icon_logo")
            imageView.snp.makeConstraints {
                $0.height.equalTo(height)
                $0.center.equalToSuperview()
            }
        case "手机号码":
            cell.contentView.addSubview(inpuText)
            inpuText.keyboardType = .numberPad
            leftImage.image = #imageLiteral(resourceName: "user_name")
            inpuText.text = userNum
        case "密码":
            cell.contentView.addSubview(inpuText)
            inpuText.isSecureTextEntry = true
            inpuText.keyboardType = .alphabet
            leftImage.image = #imageLiteral(resourceName: "lock")
            inpuText.text = password
        case "登   录":
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
        case "注册新用户or忘记密码":
            let titles = source[indexPath.row].components(separatedBy: "or")
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
        case "icon":
            return 180
        case "登   录":
            return 80
        default:
            return 65
        }
    }
}
