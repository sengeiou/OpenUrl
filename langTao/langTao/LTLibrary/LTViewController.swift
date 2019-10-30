//
//  LTViewController.swift
//  cameraman
//
//  Created by haozhiyu on 2019/3/11.
//  Copyright © 2019 haozhiyu. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class LTViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = LTTheme.keyViewBG
        automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
        modalPresentationStyle = .fullScreen
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    func reloadLocalString() {
        
    }
    
    func addNoDataView(inView: UIView, text: String? = nil) {
        removeNoDataView(formView: inView)
        let noDataView = UILabel()
        noDataView.tag = 586
        noDataView.text = "No data".localString
        if let t = text {
            noDataView.text = t
        }
        inView.addSubview(noDataView)
        
        noDataView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func removeNoDataView(formView: UIView) {
        if let noDataView = formView.viewWithTag(586) {
            noDataView.removeFromSuperview()
        }
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
        #if DEBUG
        print("\(self)销毁了~~~")
        #endif
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return.darkContent
        } else {
            return .default
        }
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
