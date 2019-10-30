//
//  LTDeviceInfoController.swift
//  coolPer
//
//  Created by LonTe on 2019/7/24.
//  Copyright © 2019 LangTe. All rights reserved.
//

import UIKit
import YYFast

class LTDeviceInfoController: LTViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "绑定设备"
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
    }
    
    @objc func sureAction() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
