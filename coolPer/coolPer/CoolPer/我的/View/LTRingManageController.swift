//
//  LTRingManageController.swift
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
//  Created by LonTe on 2019/10/14.
//  Copyright © 2019 LangTe. All rights reserved.
//


import UIKit

class LTRingManageController: LTViewController {
    struct RuningData {
        var name: String
        var status: String
    }

    let dataSource = [
        RuningData(name: "朗特-V110型手环", status: "已连接"),
        RuningData(name: "朗特-S58型手环", status: "未连接"),
        RuningData(name: "朗特-Dov型手环", status: "未连接")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "手环管理"
        
        let table = UITableView(frame: .zero, style: .plain)
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 100
        table.sectionHeaderHeight = 8
        table.sectionFooterHeight = 8
        view.addSubview(table)
        table.backgroundColor = .white
        table.register(LTRingCell.self, forCellReuseIdentifier: String(describing: LTRingCell.self))
        
        let tableHeader = UIView(frame: CGRect(x: 0, y: 0, width: KEYSCREEN_W, height: 50))
        let msg = UILabel()
        msg.font = UIFont.systemFont(ofSize: 15)
        msg.text = "我的设备"
        msg.textColor = .darkGray
        tableHeader.addSubview(msg)
        
        msg.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        table.tableHeaderView = tableHeader
        
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

extension LTRingManageController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LTRingCell.self), for: indexPath)
        if let c = cell as? LTRingCell {
            c.cellData = dataSource[indexPath.section]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
