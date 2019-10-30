//
//  LTLanguageController.swift
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
//  Created by LonTe on 2019/8/15.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

class LTLanguageController: LTViewController {
    var table: UITableView!
    var dataSouce = [["Using System Language".localString], ["简体中文", "English"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Language".localString
        // Do any additional setup after loading the view.
        addList()
    }
    
    override func reloadLocalString() {
        title = "Language".localString
        dataSouce = [["Using System Language".localString], ["简体中文", "English"]]
        table.reloadData()
    }
    
    func addList() {
        table = UITableView(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 44
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

extension LTLanguageController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSouce.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSouce[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = dataSouce[indexPath.section][indexPath.row]
        switch dataSouce[indexPath.section][indexPath.row] {
        case "Using System Language".localString:
            if LTLocalLanguage.shared.currentLanguage == .auto {
                cell.accessoryType = .checkmark
            }
        case "简体中文":
            if LTLocalLanguage.shared.currentLanguage == .zh {
                cell.accessoryType = .checkmark
            }
        case "English":
            if LTLocalLanguage.shared.currentLanguage == .en {
                cell.accessoryType = .checkmark
            }
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch dataSouce[indexPath.section][indexPath.row] {
        case "Using System Language".localString:
            if LTLocalLanguage.shared.currentLanguage == .auto {
                return
            }
            LTHUD.show()
            DispatchQueue.main.asyncAfter(wallDeadline: .now()+1.5) {
                LTHUD.hide()
                LTLocalLanguage.shared.changCurrentLanguage(idendifiy: .auto)
            }
        case "简体中文":
            if LTLocalLanguage.shared.currentLanguage == .zh {
                return
            }
            LTHUD.show()
            DispatchQueue.main.asyncAfter(wallDeadline: .now()+1.5) {
                LTHUD.hide()
                LTLocalLanguage.shared.changCurrentLanguage(idendifiy: .zh)
            }
        case "English":
            if LTLocalLanguage.shared.currentLanguage == .en {
                return
            }
            LTHUD.show()
            DispatchQueue.main.asyncAfter(wallDeadline: .now()+1.5) {
                LTHUD.hide()
                LTLocalLanguage.shared.changCurrentLanguage(idendifiy: .en)
            }
        default:
            break
        }
    }
}

