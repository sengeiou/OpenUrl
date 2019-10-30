//
//  LTUserInfoViewController.swift
//  coolPer
//
//  Created by LonTe on 2019/7/22.
//  Copyright © 2019 LangTe. All rights reserved.
//

import UIKit
import YYFast

class LTUserInfoViewController: LTViewController {
    let source = ["头像", "昵称", "生日", "身高", "体重", "每日目标", "下一步  绑定设备", "没有设备，先体验酷跑>>>"]
    var birthdayDate = Date()
    lazy var userIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "q_place")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    var nick = ""
    var birthday = ""
    var tall = ""
    var weight = ""
    var walk = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "填写资料"
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
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
        case "请填写昵称":
            nick = inpu.text ?? ""
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
        sublimt(isNext: true)
    }
    
    func sublimt(isNext: Bool) {
        view.endEditing(true)
//        if nick.count == 0 {
//            LTHUD.show(text: "请填写昵称")
//            return
//        }
//        if birthday.count == 0 {
//            LTHUD.show(text: "请选择生日")
//            return
//        }
//        if tall.count == 0 {
//            LTHUD.show(text: "请填写身高")
//            return
//        }
//        if weight.count == 0 {
//            LTHUD.show(text: "请填写体重")
//            return
//        }
//        if walk.count == 0 {
//            LTHUD.show(text: "请填写每日目标")
//            return
//        }
        if isNext {
            let bingVC = LTBingDeviceController()
            bingVC.isLogin = true
            navigationController?.pushViewController(bingVC, animated: true)
        } else {
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func openCamear(_ sourceType: UIImagePickerController.SourceType) {
        let imagePicker = LTImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        navigationController?.present(imagePicker, animated: true, completion: nil)
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

extension LTUserInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            userIcon.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension LTUserInfoViewController: UITableViewDelegate, UITableViewDataSource {
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
        case "头像":
            cell.contentView.addSubview(inpuText)
            inpuText.isEnabled = false
            
            cell.contentView.addSubview(userIcon)
            userIcon.frame = CGRect(x: 0, y: inpuText.frame.minY, width: inpuText.frame.height-6, height: inpuText.frame.height-6)
            userIcon.frame.origin.x = inpuText.frame.maxX-userIcon.frame.height
            userIcon.layer.cornerRadius = userIcon.frame.height/2
            userIcon.layer.masksToBounds = true
        case "昵称":
            cell.contentView.addSubview(inpuText)
            inpuText.keyboardType = .default
            inpuText.textAlignment = .left
            inpuText.placeholder = "请填写昵称"
            inpuText.text = nick
        case "生日":
            cell.contentView.addSubview(inpuText)
            inpuText.textAlignment = .left
            inpuText.placeholder = "请选择生日"
            inpuText.text = birthday
            inpuText.isEnabled = false
            cell.accessoryType = .disclosureIndicator
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
        case "下一步  绑定设备":
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
        case "没有设备，先体验酷跑>>>":
            cell.contentView.addSubview(inpuText)
            inpuText.isEnabled = false
            inpuText.text = source[indexPath.row]
            inpuText.font = UIFont.boldSystemFont(ofSize: 16)
            inpuText.leftView = nil
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: KEYSCREEN_W, bottom: 0, right: 0)
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch source[indexPath.row] {
        case "头像":
            view.endEditing(true)
            let alert = UIAlertController(title: "", message: "请选择头像上传的方式", preferredStyle: .actionSheet)
            if #available(iOS 13.0, *) {
                alert.overrideUserInterfaceStyle = .light
            } 
            alert.addAction(UIAlertAction(title: "相册", style: .default, handler: { (_) in
                self.openCamear(.photoLibrary)
            }))
            alert.addAction(UIAlertAction(title: "相机", style: .default, handler: { (_) in
                self.openCamear(.camera)
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            navigationController?.present(alert, animated: true, completion: nil)
        case "生日":
            view.endEditing(true)
            let datePicker = LTDatePicket(frame: CGRect(x: 0, y: 0, width: KEYSCREEN_W, height: KEYSCREEN_H)) { [weak self] date in
                guard let `self` = self else { return }
                let calendar = Calendar.current
                let year = calendar.component(.year, from: date)
                let month = calendar.component(.month, from: date)
                let day = calendar.component(.day, from: date)
                
                self.birthday = "\(year)年\(month)月\(day)日"
                self.birthdayDate = date
                tableView.reloadData()
            }
            if birthday.count != 0 {
                datePicker.selecData = birthdayDate
            }
            datePicker.show()
        case "没有设备，先体验酷跑>>>":
            sublimt(isNext: false)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch source[indexPath.row] {
        case "下一步  绑定设备":
            return 80
        default:
            return 60
        }
    }
}
