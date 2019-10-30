//
//  LTChangNikeController.swift
//  langTao
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
//  Created by LonTe on 2019/8/17.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

class LTChangNikeController: LTViewController {
    var name: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Modify nickname".localString
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit".localString, style: .plain, target: self, action: #selector(submitAction))
        
        name = UITextField()
        name.backgroundColor = UIColor.white
        name.layer.cornerRadius = 5
        name.clearButtonMode = .whileEditing
        name.leftViewMode = .always
        name.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(name)
        name.placeholder = "Enter nicknames".localString
        name.text = LTUserViewModel.shared.user?.data.user.nickname
        
        let left = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        name.leftView = left
        
        name.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
    }
    
    @objc func submitAction() {
        view.endEditing(true)
        if name.text?.count == 0 {
            LTHUD.show(text: "Please enter a nickname".localString)
            return
        }
        if name.text == LTUserViewModel.shared.user?.data.user.nickname {
            navigationController?.popViewController(animated: true)
            return
        }
        guard var user = LTUserViewModel.shared.user else {
            return
        }
        LTUserViewModel.shared.modiyUserinfo(param: ["id" : user.data.user.id, "nickname" : name.text!]) { [weak self] (result) in
            guard let `self` = self else { return }
            if case .success = result {
                user.data.user.nickname = self.name.text
                guard let data = try? JSONEncoder().encode(user) else { return }
                UserDefaults.standard.setValue(data, forKey: USERMODELCACHE)
                UserDefaults.standard.synchronize()
                LTHUD.show(text: "Modified success".localString)
                DispatchQueue.main.asyncAfter(wallDeadline: .now()+1.5, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
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
