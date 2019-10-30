//
//  LTHomeViewController.swift
//  langTao
//
//  Created by LonTe on 2019/7/26.
//  Copyright © 2019 LonTe. All rights reserved.
//

import UIKit

class LTHomeViewController: LTViewController {
    var isShow = false
    let homeViewModel = LTHomeViewModel()
    let detailViewModel = LTDetailViewModel()
    var collect: UICollectionView?
    var banner: LTBanner?
    var navbar: UIView?
    var search: UITextField?
    var line: UILabel?
    let inset: CGFloat = 11*2
    var sectionFlag = ["topItem", "HOT".localString]
    let topItemImages = [#imageLiteral(resourceName: "new"), #imageLiteral(resourceName: "factory"), #imageLiteral(resourceName: "supply_company"), #imageLiteral(resourceName: "bluetooth"), #imageLiteral(resourceName: "data_line"), #imageLiteral(resourceName: "local"), #imageLiteral(resourceName: "world"), #imageLiteral(resourceName: "supply"), #imageLiteral(resourceName: "hr"), #imageLiteral(resourceName: "contact")]
    var topItemTitles = ["New".localString, "Factory".localString, "Supplier".localString, "Joint Venture".localString, "Fume".localString]
//    var topItemTitles = ["New".localString, "Factory".localString, "Supplier".localString, "Joint Venture".localString, "Fume".localString, "Domestic".localString, "Global".localString, "Tradeleads".localString, "Recruit".localString, "Contact Us".localString]
    var isLight = true {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home".localString
        // Do any additional setup after loading the view.

        addListView()
        addCustomNavBar()
        configListView()
        addHeader()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(updataSearchKey), name: NSNotification.Name(rawValue: SEARCHKEY), object: nil)
    }
    
    @objc func updataSearchKey() {
        search?.placeholder = UserDefaults.standard.string(forKey: SEARCHKEY)
    }
    
    override func reloadLocalString() {
        title = "Home".localString
        sectionFlag = ["topItem", "HOT".localString]
        topItemTitles = ["New".localString, "Factory".localString, "Supplier".localString, "Joint Venture".localString, "Fume".localString]
//        topItemTitles = ["New".localString, "Factory".localString, "Supplier".localString, "Joint Venture".localString, "Fume".localString, "Domestic".localString, "Global".localString, "Tradeleads".localString, "Recruit".localString, "Contact Us".localString]
        collect?.reloadData()
    }
    
    func addListView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collect = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collect?.delegate = self
        collect?.dataSource = self
        collect?.alwaysBounceVertical = true
        view.addSubview(collect!)
        collect?.backgroundColor = LTTheme.keyViewBG
        collect?.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let bannerH: CGFloat = KEYSCREEN_W/16*9
        banner = LTBanner(frame: CGRect(x: 0, y: -bannerH-64, width: KEYSCREEN_W, height: bannerH))
        banner?.placeholder = IMGPLACEHOLDER
        collect?.addSubview(banner!)
        banner?.clickCurrentPage({ [weak self] (index) in
            guard let `self` = self else { return }
            if let bannerModels = self.homeViewModel.banners {
                self.detailViewModel.enterpriseById(id: bannerModels[index].eid) { [weak self] (result) in
                    if case .success = result {
                        guard let `self` = self else { return }
                        let vc = LTFactroyDetailController()
                        vc.detailModel = self.detailViewModel.detailModel
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        })
    }
    
    func addCustomNavBar() {
        navbar = UIView(frame: CGRect(x: 0, y: banner!.frame.maxY, width: KEYSCREEN_W, height: 64))
        navbar?.backgroundColor = UIColor.white.withAlphaComponent(0)
        collect?.addSubview(navbar!)
        
        let searchBg = UIView(frame: .zero)
        searchBg.backgroundColor = UIColor.white
        navbar?.addSubview(searchBg)
        searchBg.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        search = UITextField()
        search?.borderStyle = .none
        search?.placeholder = UserDefaults.standard.string(forKey: SEARCHKEY)
        search?.font = UIFont.systemFont(ofSize: 13)
        search?.backgroundColor = RGB(239, 239, 241)
        searchBg.addSubview(search!)
        search?.frame = CGRect(x: inset/2, y: inset/2, width: KEYSCREEN_W-inset, height: 64-inset)
        search?.leftViewMode = .always
        search?.layer.cornerRadius = 5
        search?.delegate = self
        
        let leftImage = UIImageView(image: #imageLiteral(resourceName: "search"))
        leftImage.contentMode = .scaleAspectFit
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: search!.frame.height, height: search!.frame.height))
        leftView.addSubview(leftImage)
        leftImage.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 7, left: 10, bottom: 5, right: 10))
        }
        search?.leftView = leftView
        
        if UIDevice.current.isX() {
            navbar?.frame.origin.y = banner!.frame.maxY-24
            navbar?.frame.size.height = 88
        }
        
        line = UILabel(frame: CGRect(x: 0, y: navbar!.frame.height-0.5, width: navbar!.frame.width, height: 0.5))
        line?.backgroundColor = UIColor.lightGray.withAlphaComponent(0)
        navbar?.addSubview(line!)
    }
    
    func configListView() {
        collect?.contentInset = UIEdgeInsets(top: banner!.frame.height+64, left: 0, bottom: 0, right: 0)
        collect?.register(LTHomeTopItemCell.self, forCellWithReuseIdentifier: String(describing: LTHomeTopItemCell.self))
        collect?.register(LTHotItemCell.self, forCellWithReuseIdentifier: String(describing: LTHotItemCell.self))
        collect?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
        
        collect?.register(LTHotTitleView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: LTHotTitleView.self))
        collect?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: UICollectionReusableView.self))
    }
    
    func addHeader() {
        let slack = SlackLoadingAnimator()
        slack.insets = UIEdgeInsets(top: -banner!.frame.height-64, left: 0, bottom: banner!.frame.height+64, right: 0)
        let header = collect?.cr.addHeadRefresh(animator: slack, handler: { [weak self] in
            guard let `self` = self else { return }
            self.loadData()
        })
        header?.superview?.sendSubviewToBack(header!)
    }
    
    func loadData() {
        homeViewModel.productVisits { [weak self] (result) in
            guard let `self` = self else { return }
            if let bannerModels = self.homeViewModel.banners {
                var banners = [BannerItem]()
                for banner in bannerModels {
                    banners.append(BannerItem(image: banner.url, title: ""))
                }
                self.banner?.images = banners
            }
            if let show = self.homeViewModel.bulletinBoard?.state, show == "1" {
                self.isShow = true
            } else {
                self.isShow = false
            }
            self.collect?.cr.endHeaderRefresh()
            self.collect?.reloadData()
        }
        
        homeViewModel.allSort { (result) in
            if case .success = result {            
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: SEARCHKEY), object: nil)
            }
        }
    }
    
    func topItemAction(sort: String) {
        switch sort {
        case "New".localString:
            let vc = LTNewProductController()
            vc.title = sort
            navigationController?.pushViewController(vc, animated: true)
        case "Factory".localString:
            let vc = LTFactoryController()
            vc.title = sort
            vc.sortId = "1164463503285817344"
            navigationController?.pushViewController(vc, animated: true)
        case "Supplier".localString:
            let vc = LTSupplierController()
            vc.title = sort
            navigationController?.pushViewController(vc, animated: true)
//        case "Joint Venture".localString:
        case "Fume".localString:
            let vc = LTFactoryController()
            vc.title = sort
            vc.sortId = "1164464314019614720"
            navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = LTConnectUsViewController()
            vc.title = sort
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        if (LTUserViewModel.shared.user == nil) {
            navigationController?.present(LTNavigationController(rootViewController: LTLoginViewController()), animated: true, completion: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isLight {
            return .lightContent
        }
        return .default
    }
    
    deinit {
        #if DEBUG
        print("\(self)销毁了~~~")
        #endif
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SEARCHKEY), object: nil)
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

extension LTHomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionFlag.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sectionFlag[section] {
        case "topItem":
            if isShow {
                return topItemTitles.count
            } else {
                return 0
            }
        case "HOT".localString:
            return homeViewModel.hotModels?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sectionFlag[indexPath.section] {
        case "topItem":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LTHomeTopItemCell.self), for: indexPath)
            if let icell = cell as? LTHomeTopItemCell {
                icell.imageView?.image = topItemImages[indexPath.item]
                icell.label?.text = topItemTitles[indexPath.item]
            }
            return cell
        case "HOT".localString:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LTHotItemCell.self), for: indexPath)
            if let icell = cell as? LTHotItemCell {
                icell.model = homeViewModel.hotModels?[indexPath.item]
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self), for: indexPath)
            cell.contentView.backgroundColor = RGB(CGFloat(arc4random()%255), CGFloat(arc4random()%255), CGFloat(arc4random()%255))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sectionFlag[indexPath.section] {
        case "topItem":
            topItemAction(sort: topItemTitles[indexPath.item])
        default:
            let vc = LTProductDetailsController()
            vc.productModel = homeViewModel.hotModels![indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            switch sectionFlag[indexPath.section] {
            case "HOT".localString:
                let reusable = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: LTHotTitleView.self), for: indexPath)
                if let iReusable = reusable as? LTHotTitleView {
                    iReusable.label?.text = sectionFlag[indexPath.section]
                }
                return reusable
            default:
                let reusable = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: UICollectionReusableView.self), for: indexPath)
                return reusable
            }
        } else {
            let reusable = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: UICollectionReusableView.self), for: indexPath)
            reusable.backgroundColor = .white
            return reusable
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sectionFlag[indexPath.section] {
        case "topItem":
            let width = (KEYSCREEN_W-1)/5
            return CGSize(width: width, height: width)
        case "HOT".localString:
            let width = (KEYSCREEN_W-30)/2
            return CGSize(width: width, height: width+60)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch sectionFlag[section] {
        case "HOT".localString:
            return 10
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch sectionFlag[section] {
        case "HOT".localString:
            return 10
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch sectionFlag[section] {
        case "HOT".localString:
            return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch sectionFlag[section] {
        case "HOT".localString:
            return CGSize(width: KEYSCREEN_W, height: 45)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        switch sectionFlag[section] {
        case "topItem".localString:
            if isShow {
                return CGSize(width: KEYSCREEN_W, height: 10)
            } else {
                return .zero
            }
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        view.layer.zPosition = 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collect {
            var topHeight: CGFloat = 20
            var offset: CGFloat = 0
            if UIDevice.current.isX() {
                topHeight = 44
                offset = 24
            }
            let searchFrame = scrollView.contentOffset.y+topHeight
            if searchFrame >= -64 {
                var scale = CGFloat(fabsf(Float(-64-searchFrame))/20)
                if scale > 1 {
                    scale = 1
                }
                let insetY: CGFloat = 5*2
                search?.frame = CGRect(x: inset/2, y: inset/2+((insetY-inset)/2+20)*scale, width: KEYSCREEN_W-inset, height: 64-inset-(insetY-inset+20)*scale)
                navbar?.backgroundColor = UIColor.white.withAlphaComponent(scale)
                line?.backgroundColor = UIColor.lightGray.withAlphaComponent(scale/1.2)
            } else {
                search?.frame = CGRect(x: inset/2, y: inset/2, width: KEYSCREEN_W-inset, height: 64-inset)
                navbar?.backgroundColor = UIColor.white.withAlphaComponent(0)
                line?.backgroundColor = UIColor.lightGray.withAlphaComponent(0)
            }
            if scrollView.contentOffset.y >= -navbar!.frame.height {
                navbar?.frame.origin.y = scrollView.contentOffset.y
                isLight = false
            } else {
                navbar?.frame.origin.y = banner!.frame.maxY-offset
                isLight = true
            }
        }
    }
}

extension LTHomeViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let searchVC = LTSearchViewController()
        searchVC.placeholder = search?.placeholder
        navigationController?.pushViewController(searchVC, animated: false)
        return false
    }
}
