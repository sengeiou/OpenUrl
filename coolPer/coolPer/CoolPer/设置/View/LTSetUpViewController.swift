//
//  LTSetUpViewController.swift
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

class LTSetUpViewController: LTViewController {
    var table: UITableView!
    let source = ["久坐提醒", "自动同步数据", "关于"]

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
        table.rowHeight = 65
        table.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
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

extension LTSetUpViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = source[indexPath.row]
        cell.selectionStyle = .none
        switch source[indexPath.row] {
        case "久坐提醒":
            let switchBtn = UISwitch()
            switchBtn.isOn = true
            cell.accessoryView = switchBtn
            
            return cell
        case "自动同步数据":
            let switchBtn = UISwitch()
            switchBtn.isOn = false
            cell.accessoryView = switchBtn
            
            return cell
        case "测量设置", "关于":
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch source[indexPath.row] {
        case "关于":
            navigationController?.pushViewController(LTAboutViewController(), animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "智能手环设置"
    }
}
