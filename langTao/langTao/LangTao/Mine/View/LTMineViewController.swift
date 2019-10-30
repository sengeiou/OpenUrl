//
//  LTMineViewController.swift
//  langTao
//
//  Created by LonTe on 2019/7/26.
//  Copyright © 2019 LonTe. All rights reserved.
//

import UIKit
import Accelerate
import Photos

class LTMineViewController: LTViewController {
    let viewModel = LTMeViewModel()
    var loadEstatus = true
    
    var isLight = true {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    var imageBG: UIImageView?
    var collect: UICollectionView?
    
    var topView: UIView?
    var navBar: UIView?
    var whiteBtn: UIButton?
    var blackBtn: UIButton?
    var titleLabel: UILabel?
    var showTitle: UILabel?
    var line: UILabel?
    var userIcon: UIImageView?
    var userName: UILabel?
    var whiteView: UIView?
    var ename: UILabel?
    var height: CGFloat = 0
    
    var iconData = [LTIconModel(title: "Enterprise residence".localString, image: #imageLiteral(resourceName: "商家申请入驻")), LTIconModel(title: "Enterprise management".localString, image: #imageLiteral(resourceName: "店铺管理")), LTIconModel(title: "Product management".localString, image: #imageLiteral(resourceName: "商品管理"))]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Me".localString
        // Do any additional setup after loading the view.
        
        addScrollView()
        addCustomNavBar()
    }
    
    override func reloadLocalString() {
        titleLabel?.text = "Me".localString
        showTitle?.text = "Me".localString
        title = "Me".localString
        updateUI()
    }
    
    func addScrollView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: KEYSCREEN_W/3, height: KEYSCREEN_W/3)
        collect = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collect?.backgroundColor = view.backgroundColor
        collect?.delegate = self
        collect?.dataSource = self
        collect?.alwaysBounceVertical = true
        view.addSubview(collect!)
        collect?.register(LTMeCell.self, forCellWithReuseIdentifier: String(describing: LTMeCell.self))
        
        collect?.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let userHeader = UIView(frame: CGRect(x: 0, y: 0, width: KEYSCREEN_W, height: KEYSCREEN_W))
        imageBG = UIImageView(frame: userHeader.frame)
        imageBG?.contentMode = .scaleAspectFill
        imageBG?.backgroundColor = LTTheme.select
        imageBG?.clipsToBounds = true
        userHeader.clipsToBounds = false
        userHeader.addSubview(imageBG!)
        
        showTitle = UILabel()
        showTitle?.font = UIFont.boldSystemFont(ofSize: 20)
        showTitle?.textColor = UIColor.white
        showTitle?.text = "Me".localString
        userHeader.addSubview(showTitle!)
        
        let top: CGFloat = UIDevice.current.isX() ? 44 : 20
        showTitle?.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(top+22)
        }
        
        userIcon = UIImageView()
        userIcon?.image = #imageLiteral(resourceName: "userIcon")
        userHeader.addSubview(userIcon!)
        userIcon?.isUserInteractionEnabled = true
        
        let iconTap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        userIcon?.addGestureRecognizer(iconTap)
        
        userIcon?.snp.makeConstraints({
            $0.top.equalTo(showTitle!.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        })
        
        userName = UILabel()
        userName?.font = UIFont.boldSystemFont(ofSize: 20)
        userName?.textColor = UIColor.white
        userHeader.addSubview(userName!)
        
        userName?.snp.makeConstraints({
            $0.top.equalTo(userIcon!.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        })
        
        userHeader.layoutIfNeeded()
        userIcon?.layer.cornerRadius = userIcon!.frame.width/2
        userIcon?.layer.borderColor = UIColor.white.cgColor
        userIcon?.layer.masksToBounds = true
        userIcon?.layer.borderWidth = 2
                
        collect?.addSubview(userHeader)
        
        whiteView = UIView()
        whiteView?.backgroundColor = UIColor.white
        collect?.addSubview(whiteView!)
        whiteView?.layer.cornerRadius = 8
        whiteView?.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        whiteView?.layer.shadowOpacity = 0.5
        whiteView?.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        ename = UILabel()
        ename?.adjustsFontSizeToFitWidth = true
        ename?.textAlignment = .center
        whiteView?.addSubview(ename!)
        
        ename?.snp.makeConstraints({
            $0.left.right.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        })
    }
    
    func addCustomNavBar() {
        topView = UIView()
        topView?.backgroundColor = UIColor.white.withAlphaComponent(0)
        view.addSubview(topView!)
        
        topView?.snp.makeConstraints({
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(view.snp.topMargin)
        })
        
        navBar = UIView()
        navBar?.backgroundColor = UIColor.white.withAlphaComponent(0)
        view.addSubview(navBar!)
        
        navBar?.snp.makeConstraints({
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.snp.topMargin)
            if #available(iOS 11.0, *) {
                $0.height.equalTo(44)
            } else {
                $0.height.equalTo(64)
            }
        })
        
        whiteBtn = UIButton(type: .custom)
        whiteBtn?.setImage(#imageLiteral(resourceName: "set_white"), for: .normal)
        whiteBtn?.contentHorizontalAlignment = .right
        whiteBtn?.addTarget(self, action: #selector(setConfig), for: .touchUpInside)
        navBar?.addSubview(whiteBtn!)
        
        blackBtn = UIButton(type: .custom)
        blackBtn?.setImage(#imageLiteral(resourceName: "set_black"), for: .normal)
        blackBtn?.contentHorizontalAlignment = .right
        blackBtn?.addTarget(self, action: #selector(setConfig), for: .touchUpInside)
        blackBtn?.alpha = 0
        navBar?.addSubview(blackBtn!)
        
        whiteBtn?.snp.makeConstraints({
            $0.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(44)
            $0.width.equalTo(64)
        })
        
        blackBtn?.snp.makeConstraints({
            $0.edges.equalTo(whiteBtn!)
        })
        
        titleLabel = UILabel()
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel?.textColor = LTTheme.navTitle.withAlphaComponent(0)
        titleLabel?.text = "Me".localString
        navBar?.addSubview(titleLabel!)
        
        titleLabel?.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(navBar!.snp.bottom).offset(-24)
        })
        
        line = UILabel()
        line?.backgroundColor = UIColor.lightGray.withAlphaComponent(0)
        navBar?.addSubview(line!)
        
        line?.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    @objc func setConfig() {
        navigationController?.pushViewController(LTSettingController(), animated: true)
    }
    
    @objc func tapAction() {
        /// 数字标识器代理
        let delegate = JXPhotoBrowserBaseDelegate()
        /// 长按手势
        delegate.longPressedCallback = { [weak self] photoBrowser, index, image, long in
            guard let `self` = self else { return }
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            if #available(iOS 13.0, *) {
                alert.overrideUserInterfaceStyle = .light
            }
            alert.addAction(UIAlertAction(title: "Save to album".localString, style: .default, handler: { (_) in
                self.saveToPhotosAlbum(image: image, index: index)
            }))
            alert.addAction(UIAlertAction(title: "Cancel".localString, style: .cancel, handler: nil))
            self.currentVC?.present(alert, animated: true, completion: nil)
        }
        /// 数据源
        let dataSource = JXNetworkingDataSource(photoLoader: JXKingfisherLoader(), numberOfItems: { () -> Int in
            return 1
            }, placeholder: { (_) -> UIImage? in
                return #imageLiteral(resourceName: "userIcon")
        }) { (index) -> String? in
            if let avatar = LTUserViewModel.shared.user?.data.user.avatar {
                return avatar
            }
            return nil
        }
        /// 场景转换
        let trans = JXPhotoBrowserZoomTransitioning { [weak self] (_, _, _) -> CGRect? in
            guard let `self` = self else { return nil }
            return self.userIcon?.superview?.convert(self.userIcon!.frame, to: UIApplication.shared.keyWindow)
        }
        JXPhotoBrowser(dataSource: dataSource, delegate: delegate, transDelegate: trans).show(pageIndex: 0)
    }
    
    func saveToPhotosAlbum(image: UIImage?, index: Int) {
        guard let img = image else { return }
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: img)
        }) { (succ, _) in
            DispatchQueue.main.async {
                if succ {
                    LTHUD.show(type: .success, text: "Successful Picture Preservation".localString)
                } else {
                    LTHUD.show(type: .error, text: "Failed to save pictures".localString)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let whiteH: CGFloat = 75
        height = userName!.frame.maxY+whiteH/2+25
        userName?.superview?.frame.size.height = height
        imageBG?.frame.size.height = height
        whiteView?.frame = CGRect(x: 15, y: height-whiteH/2, width: KEYSCREEN_W-15*2, height: whiteH)
        collect?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        updateUI()
        if let userId = LTUserViewModel.shared.user?.data.user.id {
            LTUserViewModel.shared.userById(userId: userId) { [weak self] (result) in
                guard let `self` = self else { return }
                if case .success = result {
                    self.updateUI()
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        loadEstatus = true
    }
    
    func updateUI() {
        if let avatar = LTUserViewModel.shared.user?.data.user.avatar {
            userIcon?.kf.setImage(with: avatar.url, placeholder: userIcon?.image)
        } else {
            userIcon?.image = #imageLiteral(resourceName: "userIcon")
        }
        userName?.text = LTUserViewModel.shared.user?.data.user.nickname
        if let eid = LTUserViewModel.shared.user?.data.user.eid, eid.count > 0 {
            iconData = [LTIconModel(title: "Upload product".localString, image: #imageLiteral(resourceName: "上架")), LTIconModel(title: "Enterprise management".localString, image: #imageLiteral(resourceName: "店铺管理")), LTIconModel(title: "Product management".localString, image: #imageLiteral(resourceName: "商品管理"))]
            if loadEstatus {
                loadEstatus = false
                viewModel.enterpriseById(id: eid) { [weak self] (result) in
                    guard let `self` = self else { return }
                    if case .success = result {
                        if self.viewModel.detailModel?.enterprise.state == 1 {
                            self.ename?.text = "The company is under review. Please wait a moment.".localString
                            self.ename?.textColor = UIColor.black
                        } else {
                            self.ename?.text = self.viewModel.detailModel?.enterprise.name
                            self.ename?.textColor = LTTheme.select
                        }
                    }
                }
            }
        } else {
            iconData = [LTIconModel(title: "Enterprise residence".localString, image: #imageLiteral(resourceName: "商家申请入驻")), LTIconModel(title: "Enterprise management".localString, image: #imageLiteral(resourceName: "店铺管理")), LTIconModel(title: "Product management".localString, image: #imageLiteral(resourceName: "商品管理"))]
            ename?.text = "You haven't entered the company yet".localString
            ename?.textColor = UIColor.black
        }
        collect?.reloadData()
    }
    
    func isEnterprise() -> Bool {
        if let eid = LTUserViewModel.shared.user?.data.user.eid, eid.count > 0 {
            if let state = viewModel.detailModel?.enterprise.state, state != 1 {
                return true
            }
            LTHUD.show(text: "The company is under review. Please wait a moment.".localString)
            return false
        } else {
            let alert = UIAlertController(title: nil, message: "You haven't entered the company yet. Do you want to enter or not?".localString, preferredStyle: .alert)
            if #available(iOS 13.0, *) {
                alert.overrideUserInterfaceStyle = .light
            } 
            alert.addAction(UIAlertAction(title: "OK".localString, style: .default, handler: { (_) in
                self.enterpriseResidence()
            }))
            alert.addAction(UIAlertAction(title: "NO".localString, style: .cancel, handler: nil))
            navigationController?.present(alert, animated: true, completion: nil)
            return false
        }
    }
    
    func enterpriseResidence() {
        navigationController?.pushViewController(LTEnterpriseResidenceController(), animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isLight {
            return .lightContent
        }
        return .default
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

extension LTMineViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LTMeCell.self), for: indexPath)
        if let iCell = cell as? LTMeCell {
            iCell.model = iconData[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = iconData[indexPath.item]
        switch model.title {
        case "Upload product".localString:
            if isEnterprise() {
                let vc = LTUploadProductController()
                vc.enterpriseModel = viewModel.detailModel?.enterprise
                navigationController?.pushViewController(vc, animated: true)
            }
        case "Enterprise residence".localString:
            enterpriseResidence()
        case "Enterprise management".localString:
            if isEnterprise() {
                let vc = LTEnterpriseResidenceController()
                vc.controllerType = .modification
                vc.enterpriseModel = viewModel.detailModel?.enterprise
                navigationController?.pushViewController(vc, animated: true)
            }
        case "Product management".localString:
            if isEnterprise() {
                let vc = LTProductManagerController()
                vc.detailModel = viewModel.detailModel
                navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: height+whiteView!.frame.height/2+15, left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collect {
            if scrollView.contentOffset.y < 0 {
                imageBG?.frame.size = CGSize(width: KEYSCREEN_W-scrollView.contentOffset.y, height: height-scrollView.contentOffset.y)
                imageBG?.frame.origin.y = scrollView.contentOffset.y
                imageBG?.frame.origin.x = scrollView.contentOffset.y/2
            } else {
                imageBG?.frame = CGRect(x: 0, y: 0, width: KEYSCREEN_W, height: height)
            }
            view.layoutIfNeeded()
            var height: CGFloat = 64
            if UIDevice.current.isX() {
                height = 88
            }
            if let topH = topView?.frame.height, let navH = navBar?.frame.height {
                let scale = (scrollView.contentOffset.y-height+topH+navH)/(topH+navH)
                topView?.backgroundColor = UIColor.white.withAlphaComponent(scale)
                navBar?.backgroundColor = UIColor.white.withAlphaComponent(scale)
                line?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7*scale)
                titleLabel?.textColor = LTTheme.navTitle.withAlphaComponent(scale)
                blackBtn?.alpha = scale
                whiteBtn?.alpha = 1-scale
                if scale > 0.5 {
                    isLight = false
                } else {
                    isLight = true
                }
            }
        }
    }
}
