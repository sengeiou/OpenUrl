//
//  LTMeViewController.swift
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
import Kingfisher

class LTMeViewController: LTViewController {
    struct Group {
        var title: String
        var rows: [String]
    }
    let dataSource = [
        Group(title: "", rows: ["all", "only"]),
        Group(title: "更多操作", rows: ["目标设定", "手环管理", "清除缓存", "修改密码", "退出账号"])
    ]
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

extension LTMeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.selectionStyle = .none
        if dataSource[indexPath.section].title == "" {
            switch dataSource[indexPath.section].rows[indexPath.row] {
            case "all":
                let userIcon = UIImageView(image: #imageLiteral(resourceName: "q_place"))
                userIcon.contentMode = .scaleAspectFill
                userIcon.layer.cornerRadius = 40
                userIcon.layer.masksToBounds = true
                cell.contentView.addSubview(userIcon)
                
                userIcon.snp.makeConstraints {
                    $0.left.top.equalToSuperview().inset(16)
                    $0.size.equalTo(CGSize(width: 80, height: 80))
                }
                
                let infoView = UIView()
                cell.contentView.addSubview(infoView)
                
                let name = UILabel()
                name.text = "Anna\t25岁"
                name.font = UIFont.boldSystemFont(ofSize: 18)
                name.textColor = .darkGray
                infoView.addSubview(name)
                
                name.snp.makeConstraints {
                    $0.left.top.equalToSuperview()
                }
                
                let runInfo = UILabel()
                runInfo.text = "坚持跑步\t294天"
                runInfo.font = name.font
                runInfo.textColor = name.textColor
                infoView.addSubview(runInfo)

                runInfo.snp.makeConstraints {
                    $0.top.equalTo(name.snp.bottom).offset(10)
                    $0.left.bottom.equalToSuperview()
                }
                
                infoView.snp.makeConstraints {
                    $0.centerY.equalTo(userIcon)
                    $0.left.equalTo(userIcon.snp.right).offset(25)
                    $0.right.equalToSuperview()
                }
                
                let step = UILabel()
                step.text = "13469\n步"
                step.numberOfLines = 2
                step.textAlignment = .center
                step.textColor = .darkGray
                step.font = UIFont.boldSystemFont(ofSize: 17)
                cell.contentView.addSubview(step)
                
                step.snp.makeConstraints {
                    if #available(iOS 13.0, *) {
                        $0.width.equalToSuperview().dividedBy(3)
                        $0.left.equalToSuperview()
                    } else {
                        $0.width.equalTo((KEYSCREEN_W-30)/3)
                        $0.left.equalToSuperview().offset(15)
                    }
                    $0.top.equalTo(userIcon.snp.bottom).offset(5)
                    $0.bottom.equalToSuperview()
                }
                
                let kilometre = UILabel()
                kilometre.text = "180\n公里"
                kilometre.numberOfLines = step.numberOfLines
                kilometre.textAlignment = step.textAlignment
                kilometre.textColor = step.textColor
                kilometre.font = step.font
                cell.contentView.addSubview(kilometre)
                
                kilometre.snp.makeConstraints {
                    $0.size.centerY.equalTo(step)
                    $0.left.equalTo(step.snp.right)
                }
                
                let joule = UILabel()
                joule.text = "900\n大卡"
                joule.numberOfLines = step.numberOfLines
                joule.textAlignment = step.textAlignment
                joule.textColor = step.textColor
                joule.font = step.font
                cell.contentView.addSubview(joule)
                
                joule.snp.makeConstraints {
                    $0.size.centerY.equalTo(step)
                    $0.left.equalTo(kilometre.snp.right)
                }
                return cell
            case "only":
                let dataFormatter = DateFormatter()
                dataFormatter.dateFormat = "yyyy-MM-dd"

                let max = UILabel()
                max.text = "单日最高\t\t"+dataFormatter.string(from: Date())
                max.textColor = .darkGray
                max.font = UIFont.boldSystemFont(ofSize: 17)
                cell.contentView.addSubview(max)
                let size = max.sizeThatFits(.zero)
                
                max.snp.makeConstraints {
                    $0.left.top.equalToSuperview().inset(15)
                    $0.size.equalTo(size)
                }
                
                let step = UILabel()
                step.text = "3836\n步"
                step.numberOfLines = 2
                step.textAlignment = .center
                step.textColor = .darkGray
                step.font = UIFont.boldSystemFont(ofSize: 17)
                cell.contentView.addSubview(step)
                
                step.snp.makeConstraints {
                    if #available(iOS 13.0, *) {
                        $0.width.equalToSuperview().dividedBy(3)
                        $0.left.equalToSuperview()
                    } else {
                        $0.width.equalTo((KEYSCREEN_W-30)/3)
                        $0.left.equalToSuperview().offset(15)
                    }
                    $0.top.equalTo(max.snp.bottom)
                    $0.bottom.equalToSuperview()
                }
                
                let kilometre = UILabel()
                kilometre.text = "12\n公里"
                kilometre.numberOfLines = step.numberOfLines
                kilometre.textAlignment = step.textAlignment
                kilometre.textColor = step.textColor
                kilometre.font = step.font
                cell.contentView.addSubview(kilometre)
                
                kilometre.snp.makeConstraints {
                    $0.size.centerY.equalTo(step)
                    $0.left.equalTo(step.snp.right)
                }
                
                let joule = UILabel()
                joule.text = "217\n大卡"
                joule.numberOfLines = step.numberOfLines
                joule.textAlignment = step.textAlignment
                joule.textColor = step.textColor
                joule.font = step.font
                cell.contentView.addSubview(joule)
                
                joule.snp.makeConstraints {
                    $0.size.centerY.equalTo(step)
                    $0.left.equalTo(kilometre.snp.right)
                }
                return cell
            default:
                return UITableViewCell()
            }
        } else if dataSource[indexPath.section].title == "更多操作" {
            cell.textLabel?.text = dataSource[indexPath.section].rows[indexPath.row]
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            cell.textLabel?.textColor = .darkGray
            switch dataSource[indexPath.section].rows[indexPath.row] {
            case "目标设定":
                cell.accessoryType = .disclosureIndicator
            case "手环管理":
                cell.accessoryType = .disclosureIndicator
            case "清除缓存":
                cell.accessoryType = .disclosureIndicator
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16)
                KingfisherManager.shared.cache.calculateDiskStorageSize(completion: { (result) in
                    switch result {
                    case .success(let size):
                        let s = CGFloat(size)/1024.0/1024.0
                        cell.detailTextLabel?.text = String(format: "%.2fM", s)
                    case .failure(_):
                        cell.detailTextLabel?.text = "0.00M"
                    }
                })
            case "修改密码":
                cell.accessoryType = .disclosureIndicator
            case "退出账号":
                cell.accessoryType = .none
            default:
                return UITableViewCell()
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSource[indexPath.section].title == "更多操作" {
            switch dataSource[indexPath.section].rows[indexPath.row] {
            case "手环管理":
                navigationController?.pushViewController(LTRingManageController(), animated: true)
            case "目标设定":
                navigationController?.pushViewController(LTReSetRunInfoController(), animated: true)
            case "修改密码":
                navigationController?.pushViewController(LTReSetPasswordController(), animated: true)
            case "清除缓存":
                let alert = UIAlertController(title: nil, message: "是否清除缓存？", preferredStyle: .alert)
                if #available(iOS 13.0, *) {
                    alert.overrideUserInterfaceStyle = .light
                }
                alert.addAction(UIAlertAction(title: "是", style: .default, handler: { (_) in
                    KingfisherManager.shared.cache.clearDiskCache()
                    if let cell = tableView.cellForRow(at: indexPath) {
                        cell.detailTextLabel?.text = "0.00M"
                    }
                }))
                alert.addAction(UIAlertAction(title: "否", style: .cancel, handler: nil))
                navigationController?.present(alert, animated: true, completion: nil)
            case "退出账号":
                let alert = UIAlertController(title: nil, message: "是否退出当前账号", preferredStyle: .alert)
                if #available(iOS 13.0, *) {
                    alert.overrideUserInterfaceStyle = .light
                }
                alert.addAction(UIAlertAction(title: "是", style: .default, handler: { (_) in
                    self.navigationController?.present(LTNavigationController(rootViewController: LTLoginViewController()), animated: true, completion: {
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                }))
                alert.addAction(UIAlertAction(title: "否", style: .cancel, handler: nil))
                navigationController?.present(alert, animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dataSource[indexPath.section].title == "" {
            switch dataSource[indexPath.section].rows[indexPath.row] {
            case "all":
                return 180
            case "only":
                return 120
            default:
                return 0.1
            }
        }
        return 65
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].title
    }
}
