//
//  LTEnterpriseResidenceController.swift
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
//  Created by LonTe on 2019/8/29.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit
import YPImagePicker
import Photos

class LTEnterpriseResidenceController: LTViewController {
    let logoStr = "logo"
    let licenseStr = "license"
    let advertisStr = "advertis"
    var group: DispatchGroup?
    
    let viewModel = LTMeViewModel()
    enum ImageType: Int {
        case none
        case logo = 20
        case license
        case advertis
    }
    
    enum ControllerType {
        case residence
        case modification
    }
    
    var dataSource: [String] {
        let data = ["Enterprise name".localString, "Contact Phone".localString, "Enterprise address".localString, "Enterprise Logo".localString, "Introduction to Enterprises".localString, "Business License".localString, "Corporate advertising map".localString, "Enterprise residence".localString]
        return data
    }
    
    var table: UITableView!
    
    var controllerType: ControllerType = .residence
    var enterpriseModel: LTFactoryModel.FactoryModel?
    
    var imageType: ImageType = .none
    
    var name = ""
    var address = ""
    var introduction = ""
        
    var uploadDic = [String : LTUploadModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        addlist()
        // Do any additional setup after loading the view.

        switch controllerType {
        case .residence:
            title = "Enterprise residence".localString
        case .modification:
            title = "Modify enterprise information".localString
            loadUsedModel()
        }
    }
    
    func loadUsedModel() {
        if let usedModel = enterpriseModel {
            name = usedModel.name
            address = usedModel.address
            introduction = usedModel.summary
            
            uploadDic[logoStr] = LTUploadModel(image: nil, imageUrl: usedModel.logo, code: "2")
            uploadDic[licenseStr] = LTUploadModel(image: nil, imageUrl: usedModel.permit, code: "6")
            uploadDic[advertisStr] = LTUploadModel(image: nil, imageUrl: usedModel.poster, code: "7")
            
            table.reloadData()
        }
    }
    
    func addlist() {
        table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = UIColor.white
        table.estimatedRowHeight = 0
        table.estimatedSectionHeaderHeight = 0
        table.estimatedSectionFooterHeight = 0
        table.delegate = self
        table.dataSource = self
        table.separatorInset.left = KEYSCREEN_W
        view.addSubview(table)
        table.contentInset.bottom = 55
        
        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func buttonAction() {
        view.endEditing(true)
        if name.count == 0 {
            LTHUD.show(text: "Please enter the name of the enterprise".localString)
            return
        }
        if address.count == 0 {
            LTHUD.show(text: "Please enter the enterprise address".localString)
            return
        }
        if uploadDic[logoStr] == nil {
            LTHUD.show(text: "Please upload a logo map of the enterprise".localString)
            return
        }
        if introduction.count == 0 {
            LTHUD.show(text: "Please describe the background of the enterprise".localString)
            return
        }
        if uploadDic[licenseStr] == nil {
            LTHUD.show(text: "Please upload the business license of the enterprise".localString)
            return
        }
        if uploadDic[advertisStr] == nil {
            LTHUD.show(text: "Please upload an advertisement bitmap of an enterprise".localString)
            return
        }
        
        switch controllerType {
        case .residence:
            nextOne()
        case .modification:
            let alert = UIAlertController(title: nil, message: "After revising the enterprise information, we need to re-examine it to confirm whether it has been revised or not.".localString, preferredStyle: .alert)
            if #available(iOS 13.0, *) {
                alert.overrideUserInterfaceStyle = .light
            }
            alert.addAction(UIAlertAction(title: "OK".localString, style: .default, handler: { (_) in
                self.nextOne()
            }))
            alert.addAction(UIAlertAction(title: "NO".localString, style: .cancel, handler: nil))
            navigationController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func nextOne() {
        group = DispatchGroup()
        uploadDic.forEach { [weak self] (_, model) in
            guard let `self` = self else { return }
            if model.imageUrl == nil {
                group?.enter()
                self.uploadImage(model: model)
            }
        }
        
        group?.notify(queue: DispatchQueue.main, execute: { [weak self] in
            guard let `self` = self else { return}
            self.nextTwo()
        })
    }
    
    func nextTwo() {
        guard let mobile = LTUserViewModel.shared.user?.data.user.mobile else { return }

        var param = [String : String]()
        param["name"] = name
        param["summary"] = introduction
        param["address"] = address
        param["permit"] = uploadDic[licenseStr]!.imageUrl
        param["logo"] = uploadDic[logoStr]!.imageUrl
        param["poster"] = uploadDic[advertisStr]!.imageUrl
        param["mobile"] = mobile
        
        switch controllerType {
        case .residence:
            residence(param: param)
        case .modification:
            modification(param: param)
        }
    }
    
    func residence(param: [String : String]) {
        viewModel.addEnterprise(param: param) { [weak self] (result) in
            guard let `self` = self else { return }
            if case .success = result {
                LTHUD.show(text: "Successful application".localString)
                DispatchQueue.main.asyncAfter(wallDeadline: .now()+1.2, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    func modification(param: [String : String]) {
        guard let id = enterpriseModel?.id else { return }
        viewModel.modifEnteriseById(id: id, param: param) { [weak self] (result) in
            guard let `self` = self else { return }
            if case .success = result {
                LTHUD.show(text: "Successful application".localString)
                DispatchQueue.main.asyncAfter(wallDeadline: .now()+1.2, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    @objc func uploadImage(_ tap: UIGestureRecognizer) {
        view.endEditing(true)
        imageType = ImageType(rawValue: tap.view!.tag)!
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
        switch imageType {
        case .none:
            return
        case .logo:
            config.showsCrop = .rectangle(ratio: 1)
        case .license:
            config.showsCrop = .none
        case .advertis:
            config.showsCrop = .rectangle(ratio: 16/9)
        }
        
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
        switch imageType {
        case .none:
            return
        case .logo:
            if let image = photo.modifiedImage {
                uploadDic[logoStr] = LTUploadModel(image: image, imageUrl: nil, code: "2")
            }
        case .license:
            let image = photo.originalImage
            uploadDic[licenseStr] = LTUploadModel(image: image, imageUrl: nil, code: "6")
        case .advertis:
            if let image = photo.modifiedImage {
                uploadDic[advertisStr] = LTUploadModel(image: image, imageUrl: nil, code: "7")
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
        table.reloadData()
    }
    
    @objc func textDidChanged(textField: UITextField) {
        switch textField.placeholder {
        case "Please enter the name of the enterprise".localString:
            name = textField.text ?? ""
        case "Please enter the enterprise address".localString:
            address = textField.text ?? ""
        default:
            break
        }
    }
    
    /// 上传文件接口 code 1用户头像 2商家Logo保存 3商品主图 4商品附图 5商品视频 6营业执照 7广告图
    func uploadImage(model: LTUploadModel) {
        let date = Int(Date().timeIntervalSince1970*1000)
        if let data = model.image?.jpegData(compressionQuality: 0.5) {
            LTUserViewModel.shared.uploadingFile(code: model.code, param: ["\(date)_00.jpg" : MultipartFormData.FormDataProvider.data(data)]) { [weak self] (result) in
                guard let `self` = self else { return }
                if case .success = result {
                    if let imgStr = LTUserViewModel.shared.updataImgs?.first {
                        switch model.code {
                        case "2":
                            self.uploadDic[self.logoStr]!.imageUrl = imgStr
                        case "6":
                            self.uploadDic[self.licenseStr]!.imageUrl = imgStr
                        case "7":
                            self.uploadDic[self.advertisStr]!.imageUrl = imgStr
                        default:
                            break
                        }
                    }
                    self.group?.leave()
                }
            }
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

extension LTEnterpriseResidenceController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.selectionStyle = .none
        cell.separatorInset.left = 15
        
        let textField = UITextField(frame: CGRect(x: 15, y: 0, width: KEYSCREEN_W-30, height: 55))
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.clearButtonMode = .whileEditing
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(textDidChanged(textField:)), for: .editingChanged)
        
        let leftView = UILabel()
        leftView.text = "Product Category".localString
        leftView.font = UIFont.boldSystemFont(ofSize: 14)
        leftView.sizeToFit()
        leftView.frame.size.width += 5
        textField.leftView = leftView
        leftView.text = dataSource[indexPath.row]

        switch dataSource[indexPath.row] {
        case "Enterprise name".localString:
            cell.contentView.addSubview(textField)
            textField.placeholder = "Please enter the name of the enterprise".localString
            textField.text = name
            return cell
        case "Contact Phone".localString:
            cell.contentView.addSubview(textField)
            textField.text = LTUserViewModel.shared.user?.data.user.mobile
            textField.textColor = UIColor.darkGray
            textField.isEnabled = false
            return cell
        case "Enterprise address".localString:
            cell.contentView.addSubview(textField)
            textField.placeholder = "Please enter the enterprise address".localString
            textField.text = address
            return cell
        case "Enterprise Logo".localString:
            cell.contentView.addSubview(textField)
            textField.isEnabled = false
            leftView.frame.size.width = KEYSCREEN_W
            
            let image = UIImageView(image: #imageLiteral(resourceName: "添加图片"))
            image.frame = CGRect(x: textField.frame.minX, y: textField.frame.height, width: 100, height: 100)
            image.tag = ImageType.logo.rawValue
            image.contentMode = .scaleAspectFill
            image.clipsToBounds = true
            image.isUserInteractionEnabled = true
            if let uploadModel = uploadDic[logoStr] {
                image.image = uploadModel.image ?? #imageLiteral(resourceName: "placeholder")
                
                if controllerType == .modification {
                    image.kf.setImage(with: (uploadModel.imageUrl ?? "").url, placeholder: image.image)
                }
            }
            
            cell.contentView.addSubview(image)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(uploadImage(_:)))
            image.addGestureRecognizer(tap)
            
            let msg = UILabel()
            msg.text = "Please upload a logo map of the enterprise".localString
            msg.textColor = UIColor.gray.withAlphaComponent(0.7)
            msg.font = textField.font
            msg.sizeToFit()
            cell.contentView.addSubview(msg)
            msg.frame.origin.x = image.frame.minX
            msg.frame.origin.y = image.frame.maxY+15
            return cell
        case "Introduction to Enterprises".localString:
            cell.contentView.addSubview(textField)
            textField.isEnabled = false
            leftView.frame.size.width = KEYSCREEN_W
            
            let textView = LTTextView(frame: CGRect(x: textField.frame.minX, y: 55, width: KEYSCREEN_W-textField.frame.minX*2, height: 150), aFont: UIFont.systemFont(ofSize: 14), textDidChange: { [weak self] (text) in
                guard let `self` = self else { return }
                self.introduction = text
            })
            textView.placeholder = "Please describe the background of the enterprise".localString
            textView.text = introduction
            textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            textView.layer.cornerRadius = 5
            cell.contentView.addSubview(textView)
            return cell
        case "Business License".localString:
            cell.contentView.addSubview(textField)
            textField.isEnabled = false
            leftView.frame.size.width = KEYSCREEN_W
            
            let image = UIImageView(image: #imageLiteral(resourceName: "添加图片"))
            image.frame = CGRect(x: textField.frame.minX, y: textField.frame.height, width: 100, height: 100)
            image.tag = ImageType.license.rawValue
            image.contentMode = .scaleAspectFit
            image.isUserInteractionEnabled = true
            if let uploadModel = uploadDic[licenseStr] {
                image.image = uploadModel.image ?? #imageLiteral(resourceName: "placeholder")
                
                if controllerType == .modification {
                    image.kf.setImage(with: (uploadModel.imageUrl ?? "").url, placeholder: image.image)
                }
            }
            cell.contentView.addSubview(image)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(uploadImage(_:)))
            image.addGestureRecognizer(tap)
            
            let msg = UILabel()
            msg.text = "Please upload the business license of the enterprise".localString
            msg.textColor = UIColor.gray.withAlphaComponent(0.7)
            msg.font = textField.font
            msg.sizeToFit()
            cell.contentView.addSubview(msg)
            msg.frame.origin.x = image.frame.minX
            msg.frame.origin.y = image.frame.maxY+15
            return cell
        case "Corporate advertising map".localString:
            cell.contentView.addSubview(textField)
            textField.isEnabled = false
            leftView.frame.size.width = KEYSCREEN_W
            
            let image = UIImageView(image: #imageLiteral(resourceName: "placeholder"))
            image.frame = CGRect(x: textField.frame.minX, y: textField.frame.height, width: KEYSCREEN_W/3*2, height: KEYSCREEN_W/3*2/16*9)
            image.tag = ImageType.advertis.rawValue
            image.contentMode = .scaleAspectFit
            image.isUserInteractionEnabled = true
            if let uploadModel = uploadDic[advertisStr] {
                image.image = uploadModel.image ?? #imageLiteral(resourceName: "placeholder")
                
                if controllerType == .modification {
                    image.kf.setImage(with: (uploadModel.imageUrl ?? "").url, placeholder: image.image)
                }
            }
            cell.contentView.addSubview(image)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(uploadImage(_:)))
            image.addGestureRecognizer(tap)
            
            let msg = UILabel()
            msg.text = "Please upload an advertisement bitmap of an enterprise. It is suggested that the ratio of image length to width be 16:9".localString
            msg.numberOfLines = 0
            msg.textColor = UIColor.gray.withAlphaComponent(0.7)
            msg.font = textField.font
            msg.frame.size = msg.sizeThatFits(CGSize(width: KEYSCREEN_W-30, height: 0))
            cell.contentView.addSubview(msg)
            msg.frame.origin.x = image.frame.minX
            msg.frame.origin.y = image.frame.maxY+15
            msg.frame.size.width = KEYSCREEN_W-30
            return cell
        case "Enterprise residence".localString:
            let insetX = cell.separatorInset.left
            cell.separatorInset.left = KEYSCREEN_W
            let residence = UIButton(type: .custom)
            residence.backgroundColor = LTTheme.select
            switch controllerType {
            case .residence:
                residence.setTitle(dataSource[indexPath.row], for: .normal)
            case .modification:
                residence.setTitle("Modify resident information".localString, for: .normal)
            }
            residence.setTitleColor(UIColor.white, for: .normal)
            residence.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            residence.layer.cornerRadius = 5
            cell.contentView.addSubview(residence)
            residence.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            residence.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 50, left: insetX, bottom: 0, right: insetX))
            }
            return cell
        default:
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSource[indexPath.row] {
        case "Enterprise Logo".localString, "Business License".localString:
            return 55+100+15+UIFont.systemFont(ofSize: 14).lineHeight+15
        case "Introduction to Enterprises".localString:
            return 55+150+15
        case "Corporate advertising map".localString:
            let height = ("Please upload an advertisement bitmap of an enterprise. It is suggested that the ratio of image length to width be 16:9".localString as NSString).boundingRect(with: CGSize(width: KEYSCREEN_W-15*2, height: 0), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font : UIFont.systemFont(ofSize: 14)], context: nil).size.height
            return 55+KEYSCREEN_W/3*2/16*9+15+height+15
        case "Enterprise residence".localString:
            return 55+50
        default:
            return 55
        }
    }
}
