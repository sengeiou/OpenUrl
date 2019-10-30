//
//  LTFactroyDetailController.swift
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
//  Created by LonTe on 2019/8/27.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

class LTFactroyDetailController: LTViewController {
    var detailModel: LTDetailModel.DetailModel?
    var isLight = true {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    var scroll: UIScrollView?
    var contentView: UIView?

    var topView: UIView?
    var navBar: UIView?
    var line: UILabel?

    var whiteBtn: UIButton?
    var blackBtn: UIButton?
    var titleLabel: UILabel?
    
    var banner: UIImageView?
    var transView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addList()
        addFactoryBanner()
        addFactoryDetail()
        addCustomNavBar()
    }
    
    func addList() {
        scroll = UIScrollView()
        scroll?.alwaysBounceVertical = true
        scroll?.backgroundColor = view.backgroundColor
        scroll?.delegate = self
        view.addSubview(scroll!)
        
        scroll?.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView = UIView()
        contentView?.backgroundColor = view.backgroundColor
        scroll?.addSubview(contentView!)
    }
    
    func addFactoryBanner() {
        let bannerH: CGFloat = KEYSCREEN_W/16*9
        banner = UIImageView(image: IMGPLACEHOLDER)
        banner?.contentMode = .scaleAspectFill
        banner?.clipsToBounds = true
        contentView?.addSubview(banner!)
        
        banner?.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            $0.height.equalTo(bannerH)
        }
        
        if let url = detailModel?.enterprise.poster {
            banner?.kf.setImage(with: url.url, placeholder: banner?.image)
        }
        
        transView = UIView()
        transView?.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        contentView?.addSubview(transView!)
        
        transView?.snp.makeConstraints({
            $0.edges.equalTo(banner!)
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
        whiteBtn?.setImage(#imageLiteral(resourceName: "whiteBack"), for: .normal)
        whiteBtn?.contentHorizontalAlignment = .left
        whiteBtn?.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        navBar?.addSubview(whiteBtn!)
        
        blackBtn = UIButton(type: .custom)
        blackBtn?.setImage(#imageLiteral(resourceName: "blackBack"), for: .normal)
        blackBtn?.contentHorizontalAlignment = .left
        blackBtn?.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        blackBtn?.alpha = 0
        navBar?.addSubview(blackBtn!)
        
        whiteBtn?.snp.makeConstraints({
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(8)
            $0.height.equalTo(44)
            $0.width.equalTo(64)
        })
        
        blackBtn?.snp.makeConstraints({
            $0.edges.equalTo(whiteBtn!)
        })
        
        titleLabel = UILabel()
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel?.textColor = LTTheme.navTitle.withAlphaComponent(0)
        titleLabel?.text = "Business Detail".localString
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
    
    func addFactoryDetail() {
        let whiteView1 = UIView()
        whiteView1.backgroundColor = LTTheme.select
        contentView?.addSubview(whiteView1)
        
        let logo = UIImageView(image: IMGPLACEHOLDER)
        logo.contentMode = .scaleAspectFill
        logo.layer.cornerRadius = 50
        logo.layer.borderColor = UIColor.white.cgColor
        logo.layer.borderWidth = 3
        logo.layer.masksToBounds = true
        whiteView1.addSubview(logo)
        
        logo.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(-25)
            $0.width.height.equalTo(100)
        }
        
        if let logoUrl = detailModel?.enterprise.logo {
            logo.kf.setImage(with: logoUrl.url, placeholder: logo.image)
        }
        
        let ename = UILabel()
        ename.text = detailModel?.enterprise.name
        ename.font = UIFont.boldSystemFont(ofSize: 17)
        ename.textColor = UIColor.white
        ename.numberOfLines = 0
        whiteView1.addSubview(ename)
        
        ename.snp.makeConstraints {
            $0.left.equalTo(logo)
            $0.top.equalTo(logo.snp.bottom).offset(15)
        }
        
        whiteView1.snp.makeConstraints {
            $0.top.equalTo(banner!.snp.bottom).offset(1)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(ename.snp.bottom).offset(20)
        }
        
        let whiteView2 = UIView()
        whiteView2.backgroundColor = UIColor.white
        contentView?.addSubview(whiteView2)
        
        let enterpriseIntroMsg = UILabel()
        enterpriseIntroMsg.text = "Company Profile".localString
        enterpriseIntroMsg.font = UIFont.boldSystemFont(ofSize: 16)
        whiteView2.addSubview(enterpriseIntroMsg)
        
        enterpriseIntroMsg.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        let summary = UILabel()
        summary.text = detailModel?.enterprise.summary
        summary.numberOfLines = 0
        summary.font = UIFont.systemFont(ofSize: 16)
        whiteView2.addSubview(summary)
        
        summary.snp.makeConstraints {
            $0.top.equalTo(enterpriseIntroMsg.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        whiteView2.snp.makeConstraints {
            $0.top.equalTo(whiteView1.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(summary.snp.bottom).offset(20)
        }
        
        let whiteView3 = UIView()
        whiteView3.backgroundColor = UIColor.white
        contentView?.addSubview(whiteView3)
        
        let addressMsg = UILabel()
        addressMsg.text = "Company address".localString
        addressMsg.font = UIFont.boldSystemFont(ofSize: 16)
        whiteView3.addSubview(addressMsg)
        
        addressMsg.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        let address = UILabel()
        address.text = detailModel?.enterprise.address
        address.numberOfLines = 0
        address.font = UIFont.systemFont(ofSize: 16)
        whiteView3.addSubview(address)
        
        address.snp.makeConstraints {
            $0.top.equalTo(addressMsg.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        whiteView3.snp.makeConstraints {
            $0.top.equalTo(whiteView2.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(address.snp.bottom).offset(20)
        }
        
        let whiteView4 = UIView()
        whiteView4.backgroundColor = UIColor.white
        contentView?.addSubview(whiteView4)
        
        let phoneMsg = UILabel()
        phoneMsg.text = "Company Telephone".localString
        phoneMsg.font = UIFont.boldSystemFont(ofSize: 16)
        whiteView4.addSubview(phoneMsg)
        
        phoneMsg.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(16)
        }
        
        let phone = UILabel()
        phone.text = detailModel?.enterprise.mobile
        phone.isUserInteractionEnabled = true
        phone.attributedText = NSAttributedString(string: phone.text ?? "", attributes: [.underlineStyle : NSUnderlineStyle.single.rawValue])
        phone.textColor = LTTheme.select
        phone.font = UIFont.systemFont(ofSize: 16)
        whiteView4.addSubview(phone)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(call))
        phone.addGestureRecognizer(tap)
        
        phone.snp.makeConstraints {
            $0.left.equalTo(phoneMsg.snp.right).offset(10)
            $0.centerY.equalTo(phoneMsg)
        }
        
        let callBtn = UIButton(type: .custom)
        callBtn.setImage(#imageLiteral(resourceName: "电话"), for: .normal)
        callBtn.addTarget(self, action: #selector(call), for: .touchUpInside)
        whiteView4.addSubview(callBtn)
        
        callBtn.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        whiteView4.snp.makeConstraints {
            $0.top.equalTo(whiteView3.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(phoneMsg.snp.bottom).offset(20)
        }
        
        let whiteView5 = UIView()
        whiteView5.backgroundColor = UIColor.white
        contentView?.addSubview(whiteView5)
        
        let productsMsg = UILabel()
        productsMsg.text = "Company Products".localString
        productsMsg.font = UIFont.boldSystemFont(ofSize: 16)
        whiteView5.addSubview(productsMsg)
        
        productsMsg.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(16)
        }
        
        let width = (KEYSCREEN_W-30)/2
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: width+60)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectView.backgroundColor = view.backgroundColor
        collectView.delegate = self
        collectView.dataSource = self
        contentView?.addSubview(collectView)
        collectView.register(LTHotItemCell.self, forCellWithReuseIdentifier: String(describing: LTHotItemCell.self))

        collectView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(productsMsg.snp.bottom).offset(20)
            $0.height.equalTo(KEYSCREEN_W)
        }
        
        var bottonItem: UIView = collectView
        if let count = detailModel?.productList?.count {
            if count == 0 {
                addNoDataView(inView: collectView, text: "No product uploaded yet".localString)
            } else {
                var row = (count-1)/2+1
                if row > 3 {
                    row = 3
                    let loadMore = UIButton(type: .custom)
                    loadMore.setTitleColor(LTTheme.select, for: .normal)
                    loadMore.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                    loadMore.setTitle("View all products".localString, for: .normal)
                    loadMore.addTarget(self, action: #selector(loadAllProdutcs), for: .touchUpInside)
                    whiteView5.addSubview(loadMore)
                    loadMore.titleLabel?.sizeToFit()
                    bottonItem = loadMore
                    
                    loadMore.snp.makeConstraints {
                        $0.left.right.equalToSuperview()
                        $0.top.equalTo(collectView.snp.bottom)
                        $0.height.equalTo(50)
                    }
                    
                    let right = UIImageView(image: #imageLiteral(resourceName: "right"))
                    whiteView5.addSubview(right)
                    
                    right.snp.makeConstraints {
                        $0.centerY.equalTo(loadMore)
                        $0.centerX.equalTo(loadMore).offset(loadMore.titleLabel!.frame.width/2+10)
                    }
                }
                let height = (width+60)*CGFloat(row)+10.0*CGFloat(row+1)
                collectView.snp.updateConstraints {
                    $0.height.equalTo(height)
                }
            }
        } else {
            addNoDataView(inView: collectView, text: "No product uploaded yet".localString)
        }
        
        whiteView5.snp.makeConstraints {
            $0.top.equalTo(whiteView4.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottonItem.snp.bottom)
        }
        
        contentView?.snp.makeConstraints({
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalTo(whiteView5.snp.bottom).offset(50)
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isLight {
            return .lightContent
        }
        return .default
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func call() {
        DispatchQueue.main.async {
            UIApplication.shared.open(URL(string: "telprompt://"+self.detailModel!.enterprise.mobile)!)
        }
    }
     
    @objc func loadAllProdutcs() {
        let vc = LTAllProductController()
        vc.productList = detailModel!.productList
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
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

extension LTFactroyDetailController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = detailModel?.productList?.count else {
            return 0
        }
        if count > 6 {
            return 6
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LTHotItemCell.self), for: indexPath)
        if let icell = cell as? LTHotItemCell {
            icell.model = detailModel?.productList?[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = LTProductDetailsController()
        vc.productModel = detailModel!.productList![indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == scroll {
            let bannerH: CGFloat = KEYSCREEN_W/16*9
            view.layoutIfNeeded()
            if let topH = topView?.frame.height, let navH = navBar?.frame.height {
                let scale = (scrollView.contentOffset.y-(bannerH-topH-navH)+topH+navH)/(topH+navH)
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
