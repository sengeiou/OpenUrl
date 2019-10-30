//
//  LTRunLineViewController.swift
//  coolPer
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
//  Created by LonTe on 2019/10/11.
//  Copyright © 2019 LangTe. All rights reserved.
//


import UIKit

class LTRunLineViewController: LTViewController {
    var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if #available(iOS 13.0, *) {
            table = UITableView(frame: .zero, style: .insetGrouped)
        } else {
            table = UITableView(frame: .zero, style: .grouped)
        }
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 80
        table.register(LTRunLineCell.self, forCellReuseIdentifier: String(describing: LTRunLineCell.self))
        view.addSubview(table)
        
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
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

extension LTRunLineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LTRunLineCell.self), for: indexPath)
        if let c = cell as? LTRunLineCell {
            let name = ["Jack", "桃子", "小艾", "米先生", "阿仑", "Boss", "J 果儿", "卜里卡", "Lite", ".时光之年"]
            let stepNum = ["25360", "20210", "18370", "15020", "13002", "10932", "9872", "7651", "5381", "3092"]
            c.sort.text = "\(indexPath.row+1)"
            c.name.text = name[indexPath.row]
            c.stepNum.text = stepNum[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "酷跑圈排行榜↓"
    }
}
