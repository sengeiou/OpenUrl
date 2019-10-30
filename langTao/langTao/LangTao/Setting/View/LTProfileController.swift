//
//  LTProfileController.swift
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
//  Created by LonTe on 2019/8/16.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit
import YPImagePicker
import Photos

class LTProfileController: LTViewController {
    let dataSouce = [["User Icon".localString], ["Phone number".localString, "Nickname".localString], ["Change Password".localString]]
    var table: UITableView!
    let userIcon = UIImageView(image: #imageLiteral(resourceName: "userIcon"))

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile".localString
        // Do any additional setup after loading the view.
        userIcon.contentMode = .scaleAspectFill
        userIcon.clipsToBounds = true
        userIcon.layer.borderWidth = 1
        userIcon.layer.borderColor = UIColor.white.cgColor
        
        table = UITableView(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 44
        view.addSubview(table)
        
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func openSystemPhoto(sourceType: YPPickerScreen) {
        var config = YPImagePickerConfiguration()
        config.shouldSaveNewPicturesToAlbum = false
        config.colors.tintColor = navigationController!.navigationBar.tintColor
        config.hidesStatusBar = false
        config.hidesBottomBar = true
        config.showsPhotoFilters = false
        config.onlySquareImagesFromCamera = false
        config.screens = [sourceType]
        config.showsCrop = .rectangle(ratio: 1)

        let picker = YPImagePicker(configuration: config)
        picker.modalPresentationStyle = .fullScreen
        if #available(iOS 13.0, *) {
            picker.overrideUserInterfaceStyle = .light
        }
        picker.didFinishPicking { [weak picker] (items, cancel) in
            guard let `picker` = picker else { return }
            if cancel {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            
            if let photo = items.singlePhoto {
                self.pickerDidFinish(photo: photo)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        navigationController?.present(picker, animated: true, completion: nil)
    }
    
    func pickerDidFinish(photo: YPMediaPhoto) {
        if let image = photo.modifiedImage {
            let date = Int(Date().timeIntervalSince1970)
            if let data = image.jpegData(compressionQuality: 0.5) {
                LTUserViewModel.shared.uploadingFile(code: "1", param: ["\(date)_00.jpg" : MultipartFormData.FormDataProvider.data(data)]) { [weak self] (result) in
                    guard let `self` = self else { return }
                    if case .success = result {
                        if let imgStr = LTUserViewModel.shared.updataImgs?.first {
                            guard var user = LTUserViewModel.shared.user else { return }
                            
                            LTUserViewModel.shared.modiyUserinfo(param: ["id" : user.data.user.id, "avatar" : imgStr]) { (result) in
                                if case .success = result {
                                    self.userIcon.image = image
                                    user.data.user.avatar = imgStr
                                    guard let data = try? JSONEncoder().encode(user) else { return }
                                    UserDefaults.standard.setValue(data, forKey: USERMODELCACHE)
                                    UserDefaults.standard.synchronize()
                                    LTHUD.show(text: "Modified success".localString)
                                }
                            }
                        }
                    }
                }
            }
        }

        if photo.fromCamera {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: photo.originalImage)
            }) { (succ, _) in
                #if DEBUG
                print("保存成功")
                #endif
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        table.reloadData()
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

extension LTProfileController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSouce[indexPath.section][indexPath.row] {
        case "User Icon".localString:
            return 88
        default:
            return 44
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSouce.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSouce[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let height = self.tableView(tableView, heightForRowAt: indexPath)
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = dataSouce[indexPath.section][indexPath.row]
        switch dataSouce[indexPath.section][indexPath.row] {
        case "Phone number".localString:
            cell.detailTextLabel?.text = LTUserViewModel.shared.user?.data.user.mobile
            cell.accessoryType = .disclosureIndicator
        case "User Icon".localString:
            cell.textLabel?.text = nil
            cell.detailTextLabel?.text = "User Icon".localString
            cell.accessoryType = .none
            
            userIcon.removeFromSuperview()
            cell.contentView.addSubview(userIcon)
            userIcon.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(5)
                $0.left.equalToSuperview().inset(cell.separatorInset.left)
                $0.width.equalTo(userIcon.snp.height)
            }
            userIcon.layer.cornerRadius = (height-10)/2
            if let avatar = LTUserViewModel.shared.user?.data.user.avatar {
                userIcon.kf.setImage(with: avatar.url, placeholder: userIcon.image)
            }
        case "Nickname".localString:
            cell.detailTextLabel?.text = LTUserViewModel.shared.user?.data.user.nickname
            cell.accessoryType = .disclosureIndicator
        default:
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch dataSouce[indexPath.section][indexPath.row] {
        case "User Icon".localString:
            let alert = UIAlertController(title: nil, message: "Choose the way to upload?".localString, preferredStyle: .actionSheet)
            if #available(iOS 13.0, *) {
                alert.overrideUserInterfaceStyle = .light
            } 
            alert.addAction(UIAlertAction(title: "Album".localString, style: .default, handler: { (_) in
                self.openSystemPhoto(sourceType: .library)
            }))
            alert.addAction(UIAlertAction(title: "Camera".localString, style: .default, handler: { (_) in
                self.openSystemPhoto(sourceType: .photo)
            }))
            alert.addAction(UIAlertAction(title: "Cancel".localString, style: .cancel, handler: nil))
            navigationController?.present(alert, animated: true, completion: nil)
        case "Phone number".localString:
            navigationController?.pushViewController(LTChangPhoneController(), animated: true)
        case "Nickname".localString:
            navigationController?.pushViewController(LTChangNikeController(), animated: true)
        case "Change Password".localString:
            navigationController?.pushViewController(LTChangPasswordController(), animated: true)
        default:
            break
        }
    }
}
