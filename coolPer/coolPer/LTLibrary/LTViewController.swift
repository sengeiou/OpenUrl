//
//  LTViewController.swift
//  cameraman
//
//  Created by haozhiyu on 2019/3/11.
//  Copyright © 2019 haozhiyu. All rights reserved.
//

import UIKit

class LTViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = LTTheme.keyViewBG
        automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        modalPresentationStyle = .fullScreen
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func navigationShouldPopOnBackButton() -> Bool {
        view.endEditing(true)
        return true
    }
    
    deinit {
        print("\(self)销毁了~~~")
    }
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
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
