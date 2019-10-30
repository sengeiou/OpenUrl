//
//  LTUploadProductController.swift
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
//  Created by LonTe on 2019/9/2.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit
import YPImagePicker
import Photos

class LTUploadProductController: LTViewController {
    private var productDidModif: ((ModifType, LTHomeModel.ProductModel)->())?
    let maxCount = 5
    let viewModel = LTMeViewModel()
    let coverStr = "cover"
    let detailStr = "detail"
    let videoStr = "video"
    var group: DispatchGroup?
    
    enum ModifType {
        case modif
        case delete
    }
    
    enum ControllerType {
        case upload
        case modify
    }
    
    enum UploadType: Int {
        case none
        case cover = 44
        case detail
        case video
    }
    
    lazy var dataSource: [String] = {
        switch contorllerType {
        case .upload:
            let source = ["Product Name".localString, "Product Category".localString, "Product Material".localString, "Product Cover Chart".localString, "Product detail drawing".localString, "Product video".localString, "Upload product".localString]
            return source
        case .modify:
            let source = ["Product Name".localString, "Product Category".localString, "Product Material".localString, "Product Cover Chart".localString, "Product detail drawing".localString, "Product video".localString, "Modifying Products".localString]
            return source
        }
    }()
    
    var uploadType: UploadType = .none
    var contorllerType: ControllerType = .upload
    var productModel: LTHomeModel.ProductModel?
    var enterpriseModel: LTFactoryModel.FactoryModel?
    
    var name = ""
    var material = ""
    
    var productSortModel: LTSortModels.SortModel?
    
    var uploadDic = [String : [LTUploadModel]]()
    
    var table: UITableView!
    lazy var collect: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let width = (KEYSCREEN_W-51)/3
        layout.itemSize = CGSize(width: width, height: width)
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.backgroundColor = UIColor.white
        coll.delegate = self
        coll.dataSource = self
        coll.register(LTUploadCell.self, forCellWithReuseIdentifier: String(describing: LTUploadCell.self))
        coll.clipsToBounds = false
        
        let long = UILongPressGestureRecognizer(target: self, action: #selector(longAction(_:)))
        coll.addGestureRecognizer(long)
        
        return coll
    }()
    lazy var playerView: YYPlayerView = {
        let player = YYPlayerView()
        return player
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addlist()

        loadCategory()
        switch contorllerType {
        case .upload:
            title = "Upload product".localString
        case .modify:
            title = "Modify product information".localString
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete".localString, style: .plain, target: self, action: #selector(deleteProductAction))
            loadUsedModel()
        }
    }
    
    func productDidChang(block: @escaping (ModifType, LTHomeModel.ProductModel)->()) {
        productDidModif = block
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
    
    func loadCategory() {
        if let ids = enterpriseModel?.sort {
            viewModel.sortByIds(sortIds: ids) { [weak self] (result) in
                guard let `self` = self else { return }
                if case .success = result {
                    if let sorts = self.viewModel.sorts, sorts.count == 1 {
                        self.productSortModel = sorts.first
                    }
                    self.table.reloadData()
                }
            }
        }
    }
    
    func loadUsedModel() {
        if let model = productModel {
            name = model.productName ?? ""
            material = model.material ?? ""
            
            uploadDic[coverStr] = [LTUploadModel(image: nil, imageUrl: model.picture, code: "3")]
            var details = [LTUploadModel]()
            if let image = model.image {
                let images = image.components(separatedBy: ",")
                images.forEach { (url) in
                    details.append(LTUploadModel(image: nil, imageUrl: url, code: "4"))
                }
            }
            uploadDic[detailStr] = details
            if let video = model.video, video.count > 0 {
                uploadDic[videoStr] = [LTUploadModel(fileUrl: nil, videoUrl: video, code: "5")]
            }
            table.reloadData()
            collect.reloadData()
            
            viewModel.sortById(sortId: model.sort!) { [weak self] (result) in
                guard let `self` = self else { return }
                if case .success = result {
                    if let sort = self.viewModel.sort {
                        self.productSortModel = sort
                    }
                    self.table.reloadData()
                }
            }
        }
    }
    
    @objc func textDidChanged(textField: UITextField) {
        switch textField.placeholder {
        case "Please enter the product name".localString:
            name = textField.text ?? ""
        case "Please fill in the material of the product.".localString:
            material = textField.text ?? ""
        default:
            break
        }
    }
    
    @objc func uploadFile(_ tap: UIGestureRecognizer) {
        view.endEditing(true)
        if let type = tap.view?.tag {
            uploadType = UploadType(rawValue: type)!
        }
        let alert = UIAlertController(title: nil, message: "Choose the way to upload?".localString, preferredStyle: .actionSheet)
        if #available(iOS 13.0, *) {
            alert.overrideUserInterfaceStyle = .light
        }
        alert.addAction(UIAlertAction(title: "Album".localString, style: .default, handler: { (_) in
            self.openSystemPhoto(sourceType: .library)
        }))
        alert.addAction(UIAlertAction(title: "Camera".localString, style: .default, handler: { (_) in
            switch self.uploadType {
            case .video:
                self.openSystemPhoto(sourceType: .video)
            default:
                self.openSystemPhoto(sourceType: .photo)
            }
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
        switch uploadType {
        case .none:
            return
        case .cover:
            config.showsCrop = .rectangle(ratio: 1)
        case .detail:
            config.showsCrop = .none
            config.library.maxNumberOfItems = maxCount-(uploadDic[detailStr]?.count ?? 0)
            config.wordings.warningMaxItemsLimit = String(format: "You can choose up to x pictures.".localString, maxCount-(uploadDic[detailStr]?.count ?? 0))
            config.library.skipSelectionsGallery = true
        case .video:
            config.library.mediaType = .video
            config.video.fileType = .mp4
            config.video.recordingTimeLimit = 15
            config.video.trimmerMaxDuration = 15
            config.video.compression = AVAssetExportPresetMediumQuality
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
            
            self.pickerDidFinish(items: items)
            picker.dismiss(animated: true, completion: nil)
        }
        navigationController?.present(picker, animated: true, completion: nil)
    }
    
    func pickerDidFinish(items: [YPMediaItem]) {
        var models = [LTUploadModel]()
        items.forEach { (item) in
            switch item {
            case .photo(let photo):
                switch uploadType {
                case .none, .video:
                    return
                case .cover:
                    if let image = photo.modifiedImage {
                        models.append(LTUploadModel(image: image, imageUrl: nil, code: "3"))
                    }
                case .detail:
                    models.append(LTUploadModel(image: photo.originalImage, imageUrl: nil, code: "4"))
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
            case .video(let video):
                models.append(LTUploadModel(fileUrl: video.url, videoUrl: nil, code: "5"))
            }
        }
        
        switch uploadType {
        case .none:
            return
        case .cover:
            uploadDic[coverStr] = models
        case .detail:
            if uploadDic[detailStr] == nil {
                uploadDic[detailStr] = models
            } else {
                uploadDic[detailStr]! += models
            }
        case .video:
            uploadDic[videoStr] = models
        }
        table.reloadData()
        collect.reloadData()
    }
    
    /// 上传文件接口 code 1用户头像 2商家Logo保存 3商品主图 4商品附图 5商品视频 6营业执照 7广告图
    func uploadFile(model: [[String : LTUploadModel]]) {
        let date = Int(Date().timeIntervalSince1970*1000)
        var code = ""
        var param = [String : MultipartFormData.FormDataProvider]()
        model.forEach { (model) in
            if let key = model.keys.first {
                if let type = model[key]?.type {
                    switch type {
                    case .image:
                        if let data = model[key]?.image?.jpegData(compressionQuality: 0.5) {
                            param[String(format: "%d%@.jpg", date, key)] = .data(data)
                            code = model[key]?.code ?? ""
                        }
                    case .video:
                        if let url = model[key]?.fileUrl {
                            param[String(format: "%d%@.mp4", date, key)] = .file(url)
                            code = model[key]?.code ?? ""
                        }
                    }
                }
            }
        }
        
        LTUserViewModel.shared.uploadingFile(code: code, param: param) { [weak self] (result) in
            guard let `self` = self else { return }
            if case .success = result {
                if let imgStrs = LTUserViewModel.shared.updataImgs {
                    switch code {
                    case "3":
                        self.uploadDic[self.coverStr]![0].imageUrl = imgStrs.first
                    case "4":
                        imgStrs.forEach({ (imgUrl) in
                            if let range = imgUrl.range(of: "_"), !range.isEmpty {
                                let endIndex = imgUrl.index(range.upperBound, offsetBy: 2)
                                let idx = String(imgUrl[range.upperBound..<endIndex])
                                if let i = Int(idx) {
                                    self.uploadDic[self.detailStr]![i].imageUrl = imgUrl
                                }
                            }
                        })
                    case "5":
                        self.uploadDic[self.videoStr]![0].videoUrl = imgStrs.first
                    default:
                        break
                    }
                }
                self.group?.leave()
            }
        }
    }
    
    @objc func buttonAction() {
        view.endEditing(true)
        if name.count == 0 {
            LTHUD.show(text: "Please enter the product name".localString)
            return
        }
        if productSortModel == nil {
            LTHUD.show(text: "Please select product category".localString)
            return
        }
        if material.count == 0 {
            LTHUD.show(text: "Please fill in the material of the product.".localString)
            return
        }
        if uploadDic[coverStr] == nil {
            LTHUD.show(text: "Please upload a product cover map".localString)
            return
        }
        if uploadDic[detailStr] == nil {
            LTHUD.show(text: "Please upload product details, at least three".localString)
            return
        }
        if uploadDic[detailStr]!.count < 3 {
            LTHUD.show(text: "Please upload product details, at least three".localString)
            return
        }
        
        switch contorllerType {
        case .upload:
            nextOne()
        case .modify:
            let alert = UIAlertController(title: nil, message: "After modifying the product information, it is necessary to re-examine and confirm whether it has been modified or not.".localString, preferredStyle: .alert)
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
        
        uploadDic.forEach { [weak self] (_, models) in
            guard let `self` = self else { return }
            let noUrlModels = models.enumerated().filter({ (_, model) -> Bool in
                switch model.type {
                case .image:
                    return model.imageUrl == nil
                case .video:
                    return model.videoUrl == nil
                }
            })
            let uploadList = noUrlModels.map({ (index, uploadModel) -> [String : LTUploadModel] in
                return [String(format: "_%02d", index) : uploadModel]
            })
            if uploadList.count > 0 {
                group?.enter()
                self.uploadFile(model: uploadList)
            }
        }

        group?.notify(queue: DispatchQueue.main, execute: { [weak self] in
            guard let `self` = self else { return}
            self.nextTwo()
        })
    }
    
    func nextTwo() {
        var param = [String : String]()
        param["productName"] = name
        param["sort"] = productSortModel!.id
        param["eid"] = enterpriseModel!.id
        param["ename"] = enterpriseModel!.name
        param["material"] = material
        param["picture"] = uploadDic[coverStr]![0].imageUrl!
        let urls = uploadDic[detailStr]!.map { (model) -> String in
            return model.imageUrl!
        }
        param["image"] = urls.joined(separator: ",")
        param["video"] = uploadDic[videoStr]?[0].videoUrl ?? ""

        switch contorllerType {
        case .upload:
            upload(param: param)
        case .modify:
            modification(param: param)
        }
    }
    
    func upload(param: [String : String]) {
        viewModel.addProduct(param: param) { [weak self] (result) in
            guard let `self` = self else { return }
            if case .success = result {
                LTHUD.show(text: "Increase success".localString)
                DispatchQueue.main.asyncAfter(wallDeadline: .now()+1.2, execute: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    func modification(param: [String : String]) {
        if let product = productModel {
            viewModel.modifProductById(productId: product.id, param: param) { [weak self] (result) in
                guard let `self` = self else { return }
                if case .success = result {
                    LTHUD.show(text: "Successful revision".localString)
                    self.productDidModif?(.modif, product)
                    DispatchQueue.main.asyncAfter(wallDeadline: .now()+1.2, execute: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }
    
    @objc func deleteProductAction() {
        let sheet = UIAlertController(title: "Warm reminder".localString, message: "Are you sure you want to delete this product? ".localString, preferredStyle: .actionSheet)
        if #available(iOS 13.0, *) {
            sheet.overrideUserInterfaceStyle = .light
        }
        sheet.addAction(UIAlertAction(title: "NO".localString, style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Delete".localString, style: .destructive, handler: { (_) in
            self.deleteProduct()
        }))
        navigationController?.present(sheet, animated: true, completion: nil)
    }
    
    func deleteProduct() {
        if let product = productModel {
            viewModel.deleteProductById(productId: product.id) { [weak self] (result) in
                guard let `self` = self else { return }
                if case .success = result {
                    LTHUD.show(text: "Delete Successfully".localString)
                    self.productDidModif?(.delete, product)
                    DispatchQueue.main.asyncAfter(wallDeadline: .now()+1.2, execute: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }
    
    @objc func longAction(_ long: UILongPressGestureRecognizer) {
        switch long.state {
        case .began:
            let point = long.location(in: collect)
            guard let indexPath = collect.indexPathForItem(at: point) else { return }
            guard let cell = collect.cellForItem(at: indexPath) as? LTUploadCell else { return }
            cell.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1)
            collect.beginInteractiveMovementForItem(at: indexPath)
        case .changed:
            let point = long.location(in: collect)
            collect.updateInteractiveMovementTargetPosition(point)
        case .ended:
            collect.endInteractiveMovement()
        default:
            collect.cancelInteractiveMovement()
        }
    }
    
    func collectLine() -> CGFloat {
        let count = uploadDic[detailStr]?.count ?? 0
        return CGFloat((count+1-1)/3+1)
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

extension LTUploadProductController: UITableViewDelegate, UITableViewDataSource {
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
        case "Product Name".localString:
            cell.contentView.addSubview(textField)
            textField.placeholder = "Please enter the product name".localString
            textField.text = name
            return cell
        case "Product Category".localString:
            cell.contentView.addSubview(textField)
            textField.placeholder = "Please select product category".localString
            textField.isEnabled = false
            cell.accessoryType = .disclosureIndicator
            if let model = productSortModel {
                textField.text = model.sort
            }
            return cell
        case "Product Material".localString:
            cell.contentView.addSubview(textField)
            textField.placeholder = "Please fill in the material of the product.".localString
            textField.text = material
            return cell
        case "Product Cover Chart".localString:
            cell.contentView.addSubview(textField)
            textField.isEnabled = false
            leftView.frame.size.width = KEYSCREEN_W
            
            let image = UIImageView(image: #imageLiteral(resourceName: "添加图片"))
            image.frame = CGRect(x: textField.frame.minX, y: textField.frame.height, width: 100, height: 100)
            image.tag = UploadType.cover.rawValue
            image.contentMode = .scaleAspectFill
            image.clipsToBounds = true
            image.isUserInteractionEnabled = true
            if let uploadModel = uploadDic[coverStr]?.first {
                image.image = uploadModel.image ?? #imageLiteral(resourceName: "placeholder")
                
                if contorllerType == .modify {
                    image.kf.setImage(with: (uploadModel.imageUrl ?? "").url, placeholder: image.image)
                }
            }
            cell.contentView.addSubview(image)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(uploadFile(_:)))
            image.addGestureRecognizer(tap)
            
            let msg = UILabel()
            msg.text = "Please upload a product cover map".localString
            msg.textColor = UIColor.gray.withAlphaComponent(0.7)
            msg.font = textField.font
            msg.sizeToFit()
            cell.contentView.addSubview(msg)
            msg.frame.origin.x = image.frame.minX
            msg.frame.origin.y = image.frame.maxY+15
            return cell
        case "Product detail drawing".localString:
            cell.contentView.addSubview(textField)
            textField.isEnabled = false
            leftView.frame.size.width = KEYSCREEN_W
            
            cell.contentView.addSubview(collect)
            let width = (KEYSCREEN_W-50)/3
            collect.frame = CGRect(x: textField.frame.minX, y: textField.frame.maxY, width: KEYSCREEN_W-30, height: (width+10)*collectLine()-10)
            collect.viewWithTag(UploadType.detail.rawValue)?.removeFromSuperview()
            
            let image = UIImageView(image: #imageLiteral(resourceName: "添加图片"))
            image.frame = CGRect(x: 0, y: 0, width: width, height: width)
            image.layer.zPosition = 0
            if let uploadModel = uploadDic[detailStr] {
                let rows = collectLine()-1
                let columns = CGFloat(uploadModel.count%3)
                image.frame.origin.x = (width+10)*columns
                image.frame.origin.y = (width+10)*rows
                
                if uploadModel.count == maxCount {
                    image.isHidden = true
                }
            }
            image.tag = UploadType.detail.rawValue
            image.contentMode = .scaleAspectFit
            image.isUserInteractionEnabled = true
            collect.addSubview(image)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(uploadFile(_:)))
            image.addGestureRecognizer(tap)
            
            let msg = UILabel()
            msg.text = "Please upload product details, at least three.".localString
            msg.numberOfLines = 0
            msg.textColor = UIColor.gray.withAlphaComponent(0.7)
            msg.font = textField.font
            msg.frame.size = msg.sizeThatFits(CGSize(width: KEYSCREEN_W-textField.frame.minX*2, height: 0))
            cell.contentView.addSubview(msg)
            msg.frame.origin.x = textField.frame.minX
            msg.frame.origin.y = collect.frame.maxY+15
            msg.frame.size.width = KEYSCREEN_W-30
            return cell
        case "Product video".localString:
            cell.contentView.addSubview(textField)
            textField.isEnabled = false
            
            var topView: UIView = textField
            if let uploadModel = uploadDic[videoStr]?.first {
                cell.contentView.addSubview(playerView)
                
                playerView.frame = CGRect(x: textField.frame.minX, y: textField.frame.height, width: KEYSCREEN_W-textField.frame.minX*2, height: KEYSCREEN_W-textField.frame.minX*2)
                if let url = uploadModel.fileUrl {
                    playerView.play(url: url)
                } else {
                    playerView.play(url: (uploadModel.videoUrl ?? "").url!)
                }
                playerView.coverPlayType = .cycle
                playerView.clickCover { [weak self] in
                    guard let `self` = self else { return }
                    self.uploadType = .video
                    let alert = UIAlertController(title: nil, message: "Choose the way to upload?".localString, preferredStyle: .actionSheet)
                    if #available(iOS 13.0, *) {
                        alert.overrideUserInterfaceStyle = .light
                    } 
                    alert.addAction(UIAlertAction(title: "Album".localString, style: .default, handler: { (_) in
                        self.openSystemPhoto(sourceType: .library)
                    }))
                    alert.addAction(UIAlertAction(title: "Camera".localString, style: .default, handler: { (_) in
                        self.openSystemPhoto(sourceType: .video)
                    }))
                    alert.addAction(UIAlertAction(title: "Delete".localString, style: .destructive, handler: { (_) in
                        self.uploadDic.removeValue(forKey: self.videoStr)
                        self.table.reloadData()
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel".localString, style: .cancel, handler: nil))
                    self.navigationController?.present(alert, animated: true, completion: nil)
                }
                topView = playerView
            } else {
                playerView.stop()
                let image = UIImageView(image: #imageLiteral(resourceName: "添加图片"))
                image.frame = CGRect(x: textField.frame.minX, y: textField.frame.height, width: 100, height: 100)
                image.tag = UploadType.video.rawValue
                image.contentMode = .scaleAspectFit
                image.isUserInteractionEnabled = true
                cell.contentView.addSubview(image)
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(uploadFile(_:)))
                image.addGestureRecognizer(tap)
                topView = image
            }
            
            let msg = UILabel()
            msg.text = "Upload Product Videos (this option is optional)".localString
            msg.numberOfLines = 0
            msg.textColor = UIColor.gray.withAlphaComponent(0.7)
            msg.font = textField.font
            msg.frame.size = msg.sizeThatFits(CGSize(width: KEYSCREEN_W-textField.frame.minX*2, height: 0))
            cell.contentView.addSubview(msg)
            msg.frame.origin.x = textField.frame.minX
            msg.frame.origin.y = topView.frame.maxY+15
            msg.frame.size.width = KEYSCREEN_W-30
            
            return cell
        case "Upload product".localString, "Modifying Products".localString:
            let insetX = cell.separatorInset.left
            cell.separatorInset.left = KEYSCREEN_W
            let upload = UIButton(type: .custom)
            upload.backgroundColor = LTTheme.select
            upload.setTitle(dataSource[indexPath.row], for: .normal)
            upload.setTitleColor(UIColor.white, for: .normal)
            upload.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            upload.layer.cornerRadius = 5
            cell.contentView.addSubview(upload)
            upload.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            upload.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 50, left: insetX, bottom: 0, right: insetX))
            }
            return cell
        default:
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        switch dataSource[indexPath.row] {
        case "Product Category".localString:
            let vc = LTProductCategoryController { [weak self] (model) in
                guard let `self` = self else { return }
                self.productSortModel = model
                tableView.reloadData()
            }
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSource[indexPath.row] {
        case "Product Cover Chart".localString:
            return 55+100+15+UIFont.systemFont(ofSize: 14).lineHeight+15
        case "Product detail drawing".localString:
            let width = (KEYSCREEN_W-50)/3
            let height = ("Please upload product details, at least three.".localString as NSString).boundingRect(with: CGSize(width: KEYSCREEN_W-15*2, height: 0), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font : UIFont.systemFont(ofSize: 14)], context: nil).size.height
            return 55+(width+10)*collectLine()-10+15+height+15
        case "Upload product".localString, "Modifying Products".localString:
            return 55+50
        case "Product video".localString:
            if let _ = uploadDic[videoStr]?.first {
                return 55+KEYSCREEN_W-15*2+15+UIFont.systemFont(ofSize: 14).lineHeight+15
            }
            return 55+100+15+UIFont.systemFont(ofSize: 14).lineHeight+15
        default:
            return 55
        }
    }
}

extension LTUploadProductController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = uploadDic[detailStr]?.count ?? 0
        return count > maxCount ? maxCount : count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LTUploadCell.self), for: indexPath) as? LTUploadCell else {
            return UICollectionViewCell()
        }
        cell.deleteUploadModel(index: indexPath.item) { [weak self] (idx) in
            guard let `self` = self else { return }
            self.uploadDic[self.detailStr]!.remove(at: idx)
            self.table.reloadData()
            collectionView.reloadData()
        }
        if let details = uploadDic[detailStr] {
            cell.imageView.image = details[indexPath.item].image ?? #imageLiteral(resourceName: "placeholder")
            
            if contorllerType == .modify {
                cell.imageView.kf.setImage(with: (details[indexPath.item].imageUrl ?? "").url, placeholder: cell.imageView.image)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
        /// 数据源
        let dataSource = JXNetworkingDataSource(photoLoader: JXKingfisherLoader(), numberOfItems: { [weak self] () -> Int in
            guard let `self` = self else { return 0 }
            return self.uploadDic[self.detailStr]?.count ?? 0
            }, placeholder: { [weak self] (index) -> UIImage? in
                guard let `self` = self else { return IMGPLACEHOLDER }
                return self.uploadDic[self.detailStr]?[index].image
        }) { [weak self] (index) -> String? in
            guard let `self` = self else { return nil }
            return self.uploadDic[self.detailStr]?[index].imageUrl
        }
        /// 场景转换
        let trans = JXPhotoBrowserZoomTransitioning { (_, pageIndex, _) -> JXPhotoBrowserZoomTransitioningOriginResource? in
            let idx = IndexPath(item: pageIndex, section: 0)
            if let cell = collectionView.cellForItem(at: idx) as? LTUploadCell {
                return cell
            }
            return nil
        }
        JXPhotoBrowser(dataSource: dataSource, delegate: NumberPageControl(), transDelegate: trans).show(pageIndex: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let details = uploadDic[detailStr] {
            let tem = details[sourceIndexPath.item]
            uploadDic[detailStr]!.remove(at: sourceIndexPath.item)
            uploadDic[detailStr]!.insert(tem, at: destinationIndexPath.item)
        }
    }
}
