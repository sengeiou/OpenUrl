//
//  LTFeedbackController.swift
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
//  Created by LonTe on 2019/8/16.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

class LTFeedbackController: LTViewController {
    var textView: LTTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feedback".localString
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit".localString, style: .plain, target: self, action: #selector(submit))
        
        textView = LTTextView(frame: .zero)
        textView.placeholder = "Please enter your valuable comments and feedback".localString
        textView.layer.cornerRadius = 10
        textView.backgroundColor = UIColor.white
        view.addSubview(textView)
        textView.font = UIFont.systemFont(ofSize: 15)
        
        textView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(textView.snp.width).multipliedBy(2.0/3)
        }
    }

    @objc func submit() {
        view.endEditing(true)
        if textView.text.count == 0 {
            LTHUD.show(text: "Please enter your valuable comments and feedback".localString)
            return
        }
        if let creater = LTUserViewModel.shared.user?.data.user.id {
            LTUserViewModel.shared.advise(param: ["creater" : creater, "advise" : textView.text]) { [weak self] (result) in
                guard let `self` = self else { return }
                if case .success = result {
                    LTHUD.show(text: "Submit successfully".localString)
                    DispatchQueue.main.asyncAfter(wallDeadline: .now()+1.5, execute: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
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
