//
//  LTTabBarController.swift
//  langTao
//
//  Created by LonTe on 2019/7/26.
//  Copyright © 2019 LonTe. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class LTTabBarController: UITabBarController {
    var reSign = true
    
    init(withViewControllers iViewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        
//        let titles = ["Home".localString, "Class".localString, "Message".localString, "News".localString, "Me".localString]
//        let images = [#imageLiteral(resourceName: "tab1"), #imageLiteral(resourceName: "tab2"), #imageLiteral(resourceName: "tab3"), #imageLiteral(resourceName: "tab4nomel"), #imageLiteral(resourceName: "tab5")]
//        let selectImages = [#imageLiteral(resourceName: "tab1_sel"), #imageLiteral(resourceName: "tab2sel"), #imageLiteral(resourceName: "tab3sel"), #imageLiteral(resourceName: "tab4seled"), #imageLiteral(resourceName: "tab5sel")]
        
        let titles = ["Home".localString, "Class".localString, "Me".localString]
        let images = [#imageLiteral(resourceName: "tab1"), #imageLiteral(resourceName: "tab2"), #imageLiteral(resourceName: "tab5")]
        let selectImages = [#imageLiteral(resourceName: "tab1_sel"), #imageLiteral(resourceName: "tab2sel"), #imageLiteral(resourceName: "tab5sel")]

        iViewControllers.enumerated().forEach { (index, viewController) in
            viewController.tabBarItem.title = titles[index]
            viewController.tabBarItem.image = images[index]
            viewController.tabBarItem.selectedImage = selectImages[index]
        }
        
        viewControllers = iViewControllers
        NotificationCenter.default.addObserver(self, selector: #selector(reLogin), name: NSNotification.Name(rawValue: TOKENINVALID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangedLanguage), name: NSNotification.Name(rawValue: LANGUAGESCHANGED), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func reLogin() {
        if reSign {
            reSign = false
            present(LTNavigationController(rootViewController: LTLoginViewController()), animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now()+30) {
                self.reSign = true
            }
        }
    }
    
    @objc func didChangedLanguage() {
        guard let vcs = viewControllers else { return }
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done".localString
        let titles = ["Home".localString, "Class".localString, "Message".localString, "News".localString, "Me".localString]
        for (index, vc) in vcs.enumerated() {
            vc.tabBarItem.title = titles[index]
            if let nav = vc as? UINavigationController {
                for subVc in nav.viewControllers {
                    if let sub = subVc as? LTViewController {
                        sub.reloadLocalString()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    deinit {
        #if DEBUG
        print("\(self)销毁了~~~")
        #endif
        NotificationCenter.default.removeObserver(self)
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
