//
//  LTNewsViewController.swift
//  langTao
//
//  Created by LonTe on 2019/7/30.
//  Copyright © 2019 LonTe. All rights reserved.
//

import UIKit

class LTNewsViewController: LTViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News".localString
        // Do any additional setup after loading the view.
        
        addNoDataView(inView: view)
    }
    
    override func reloadLocalString() {
        title = "News".localString
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
