//
//  LTAboutUsController.swift
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

class LTAboutUsController: LTViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About us".localString
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        view.addSubview(scroll)
        
        scroll.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let content = UIView()
        view.addSubview(content)
        
        let msg = UILabel()
        msg.text = "aboutUsMsg".localString
        msg.numberOfLines = 0
        content.addSubview(msg)
        
        msg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.left.right.equalToSuperview().inset(30)
        }
        
        let logo = UIImageView(image: #imageLiteral(resourceName: "app_Icon"))
        content.addSubview(logo)
        logo.layer.cornerRadius = 20
        logo.layer.masksToBounds = true
        
        logo.snp.makeConstraints {
            $0.top.equalTo(msg.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(120)
        }
        
        let name = UILabel()
        name.text = "aboutUsTitle".localString
        content.addSubview(name)
        
        name.snp.makeConstraints {
            $0.top.equalTo(logo.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        let version = UILabel()
        if let versionStr = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            version.text = "aboutUsVersion".localString+" "+versionStr
        }
        content.addSubview(version)
        
        version.snp.makeConstraints {
            $0.top.equalTo(name.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        content.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalTo(version.snp.bottom).offset(50)
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
