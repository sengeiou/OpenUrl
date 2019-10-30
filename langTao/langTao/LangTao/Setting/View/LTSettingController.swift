//
//  LTSettingController.swift
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
import Kingfisher

class LTSettingController: LTViewController {
    var dataSouce = [["Profile".localString],
                    ["Language".localString, "Clear Cache".localString, "Version".localString],
                    ["Feedback".localString, "About us".localString],
                    ["Log out".localString]]
    var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Setup".localString
        // Do any additional setup after loading the view.
        
        addList()
    }
    
    override func reloadLocalString() {
        title = "Setup".localString
        dataSouce = [["Profile".localString],
                         ["Language".localString, "Clear Cache".localString, "Version".localString],
                         ["Feedback".localString, "About us".localString],
                         ["Log out".localString]]
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
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

extension LTSettingController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSouce.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSouce[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = dataSouce[indexPath.section][indexPath.row]
        switch dataSouce[indexPath.section][indexPath.row] {
        case "Profile".localString:
            cell.accessoryType = .disclosureIndicator
        case "Feedback".localString:
            cell.accessoryType = .disclosureIndicator
        case "Language".localString:
            cell.accessoryType = .disclosureIndicator
            switch LTLocalLanguage.shared.currentLanguage {
            case .auto:
                cell.detailTextLabel?.text = "Using System Language".localString
            case .en:
                cell.detailTextLabel?.text = "English"
            case .zh:
                cell.detailTextLabel?.text = "简体中文"
            }
        case "About us".localString:
            cell.accessoryType = .disclosureIndicator
        case "Clear Cache".localString:
            KingfisherManager.shared.cache.calculateDiskStorageSize(completion: { (result) in
                switch result {
                case .success(let size):
                    let s = CGFloat(size)/1024.0/1024.0
                    cell.detailTextLabel?.text = String(format: "%.2fM", s)
                case .failure(_):
                    cell.detailTextLabel?.text = "0.00M"
                }
            })
        case "Version".localString:
            cell.detailTextLabel?.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        default:
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch dataSouce[indexPath.section][indexPath.row] {
        case "Clear Cache".localString:
            let alert = UIAlertController(title: nil, message: "Clear image cache".localString, preferredStyle: .alert)
            if #available(iOS 13.0, *) {
                alert.overrideUserInterfaceStyle = .light
            }
            alert.addAction(UIAlertAction(title: "OK".localString, style: .default, handler: { (_) in
                KingfisherManager.shared.cache.clearDiskCache()
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.detailTextLabel?.text = "0.00M"
                }
            }))
            alert.addAction(UIAlertAction(title: "NO".localString, style: .cancel, handler: nil))
            navigationController?.present(alert, animated: true, completion: nil)
        case "Log out".localString:
            let alert = UIAlertController(title: nil, message: "Determine logout".localString, preferredStyle: .alert)
            if #available(iOS 13.0, *) {
                alert.overrideUserInterfaceStyle = .light
            } 
            alert.addAction(UIAlertAction(title: "OK".localString, style: .default, handler: { (_) in
                UserDefaults.standard.removeObject(forKey: USERMODELCACHE)
                UserDefaults.standard.synchronize()
                self.navigationController?.present(LTNavigationController(rootViewController: LTLoginViewController()), animated: true, completion: {
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                    self.navigationController?.popToRootViewController(animated: true)
                    if let window = UIApplication.shared.delegate?.window {
                        if let rootVC = window?.rootViewController as? LTTabBarController {
                            rootVC.selectedIndex = 0
                        }
                    }
                })
            }))
            alert.addAction(UIAlertAction(title: "NO".localString, style: .cancel, handler: nil))
            navigationController?.present(alert, animated: true, completion: nil)
        case "Language".localString:
            navigationController?.pushViewController(LTLanguageController(), animated: true)
        case "Profile".localString:
            navigationController?.pushViewController(LTProfileController(), animated: true)
        case "Feedback".localString:
            navigationController?.pushViewController(LTFeedbackController(), animated: true)
        case "About us".localString:
            navigationController?.pushViewController(LTAboutUsController(), animated: true)
        default:
            break
        }
    }
}
