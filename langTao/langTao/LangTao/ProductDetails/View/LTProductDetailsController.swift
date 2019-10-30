//
//  LTProductDetailsController.swift
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
//  Created by LonTe on 2019/8/7.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit
import Photos

class LTProductDetailsController: LTViewController {
    enum DetailViewType {
        case video
        case images
    }
    
    let viewModel = LTDetailViewModel()
    var viewType: DetailViewType = .images
    var isLight = true {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    var topView: UIView?
    var navBar: UIView?
    var line: UILabel?
    
    var scroll: UIScrollView?
    var contentView: UIView?
    var collect: UICollectionView?
    var transView: LTTransView?
    var numCount: UILabel?
    var videoFlag: UILabel?
    var imageFlag: UILabel?
    var seekTime: Double = 0
    
    var whiteBtn: UIButton?
    var blackBtn: UIButton?
    var titleLabel: UILabel?
    
    var productModel: LTHomeModel.ProductModel!
    var photos: [String]!
    
    lazy var player: YYPlayerView = {
        let player = YYPlayerView()
        return player
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configPhotosModel()

        addList()
        addProductPhoto()
        addProductDetail()
        addCustomNavBar()
        updateUI()
    }
    
    func configPhotosModel() {
        photos = []
        if let pic = productModel.picture {
            photos.append(pic)
        }
        if var images = productModel.image {
            images = images.replacingOccurrences(of: " ", with: "")
            let imgs = images.components(separatedBy: ",")
            photos += imgs
        }
        
        if let video = productModel.video, video.count > 0 {
            viewType = .video
            photos.insert(productModel.picture!, at: 0)
        } else {
            viewType = .images
        }
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
    
    func addProductPhoto() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: KEYSCREEN_W, height: KEYSCREEN_W)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collect = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collect?.showsHorizontalScrollIndicator = false
        collect?.alwaysBounceHorizontal = true
        collect?.backgroundColor = UIColor.white
        collect?.isPagingEnabled = true
        collect?.delegate = self
        collect?.dataSource = self
        contentView?.addSubview(collect!)
        
        collect?.register(LTDetailsPhotoCell.self, forCellWithReuseIdentifier: String(describing: LTDetailsPhotoCell.self))
        
        collect?.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.width.height.equalTo(KEYSCREEN_W)
        }
        
        transView = LTTransView()
        transView?.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        transView?.frame = CGRect(x: 0, y: 0, width: KEYSCREEN_W, height: KEYSCREEN_W)
        contentView?.addSubview(transView!)
        
        numCount = UILabel()
        numCount?.textColor = UIColor.white
        numCount?.font = UIFont.boldSystemFont(ofSize: 13)
        transView?.addSubview(numCount!)
        
        numCount?.snp.makeConstraints({
            $0.right.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(15)
        })
        
        if viewType == .video {
            let videoPlay = UIButton(type: .custom)
            videoPlay.setImage(#imageLiteral(resourceName: "播放"), for: .normal)
            videoPlay.addTarget(self, action: #selector(playAction), for: .touchUpInside)
            collect?.addSubview(videoPlay)
            
            videoPlay.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
            videoFlag = UILabel()
            videoFlag?.text = "▶︎ "+"video".localString
            videoFlag?.textColor = UIColor.white
            videoFlag?.font = UIFont.systemFont(ofSize: 9)
            videoFlag?.textAlignment = .center
            videoFlag?.backgroundColor = LTTheme.select
            var size = videoFlag!.sizeThatFits(CGSize(width: 0, height: 0))
            size.width += 15
            size.height += 8
            transView?.addSubview(videoFlag!)
            videoFlag?.layer.cornerRadius = (size.height-2)/2
            videoFlag?.layer.masksToBounds = true
            videoFlag?.isUserInteractionEnabled = true
            
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(videoOrImages(_:)))
            videoFlag?.addGestureRecognizer(tap1)
            
            videoFlag?.snp.makeConstraints {
                $0.bottom.equalToSuperview().inset(15)
                $0.right.equalTo(transView!.snp.centerX).offset(-5)
                $0.size.equalTo(size)
            }
            
            imageFlag = UILabel()
            imageFlag?.text = "picture".localString
            imageFlag?.textColor = UIColor.darkGray
            imageFlag?.font = UIFont.systemFont(ofSize: 9)
            imageFlag?.textAlignment = .center
            imageFlag?.backgroundColor = UIColor.white
            transView?.addSubview(imageFlag!)
            imageFlag?.layer.cornerRadius = (size.height-2)/2
            imageFlag?.layer.masksToBounds = true
            imageFlag?.isUserInteractionEnabled = true
            
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(videoOrImages(_:)))
            imageFlag?.addGestureRecognizer(tap2)
            
            imageFlag?.snp.makeConstraints {
                $0.bottom.equalToSuperview().inset(15)
                $0.left.equalTo(transView!.snp.centerX).offset(5)
                $0.size.equalTo(size)
            }
        }
    }
    
    @objc func videoOrImages(_ tap: UIGestureRecognizer) {
        if tap.view == imageFlag {
            self.collect?.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
        } else if tap.view == videoFlag {
            self.collect?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
            DispatchQueue.main.asyncAfter(wallDeadline: .now()+0.5) {
                self.playAction()
            }
        }
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
        titleLabel?.text = "Product Detail".localString
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
    
    func addProductDetail() {
        let whiteView1 = UIView()
        whiteView1.backgroundColor = UIColor.white
        contentView?.addSubview(whiteView1)
        
        let name = UILabel()
        name.text = productModel.productName
        name.font = UIFont.boldSystemFont(ofSize: 17)
        whiteView1.addSubview(name)
        
        let material = UILabel()
        material.text = "Subordinate material".localString+(productModel.material ?? "NoData".localString)
        material.font = UIFont.systemFont(ofSize: 15)
        material.textColor = UIColor.darkGray
        whiteView1.addSubview(material)
        
        name.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(16)
        }
        
        material.snp.makeConstraints {
            $0.left.right.equalTo(name)
            $0.top.equalTo(name.snp.bottom).offset(5)
        }
        
        whiteView1.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(collect!.snp.bottom)
            $0.bottom.equalTo(material.snp.bottom).offset(16)
        }
        
        let whiteView2 = UIView()
        whiteView2.backgroundColor = UIColor.white
        contentView?.addSubview(whiteView2)
        
        let ename = UILabel()
        ename.text = productModel.ename
        ename.font = UIFont.boldSystemFont(ofSize: 17)
        ename.textColor = LTTheme.select
        ename.numberOfLines = 0
        whiteView2.addSubview(ename)
        
        ename.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        let right = UIImageView(image: #imageLiteral(resourceName: "right"))
        whiteView2.addSubview(right)
        
        right.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        whiteView2.snp.makeConstraints {
            $0.left.right.equalTo(whiteView1)
            $0.top.equalTo(whiteView1.snp.bottom).offset(10)
            $0.bottom.equalTo(ename.snp.bottom).offset(16)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(gotoFactory))
        whiteView2.addGestureRecognizer(tap)
        
        let whiteView3 = UIView()
        whiteView3.backgroundColor = UIColor.white
        contentView?.addSubview(whiteView3)
        
        let imageMsg = UILabel()
        imageMsg.text = "Product Details Introduction Diagram".localString
        imageMsg.textColor = UIColor.gray
        imageMsg.font = UIFont.systemFont(ofSize: 15)
        whiteView3.addSubview(imageMsg)
        
        imageMsg.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(5)
            $0.top.equalToSuperview().inset(16)
        }
        
        whiteView3.snp.makeConstraints {
            $0.left.right.equalTo(whiteView1)
            $0.top.equalTo(whiteView2.snp.bottom).offset(10)
            $0.bottom.equalTo(imageMsg.snp.bottom).offset(16)
        }
        
        var topItem = whiteView3
        if var aPhotos = photos, aPhotos.count > 0 {
            aPhotos.removeFirst()
            if viewType == .video {
                aPhotos.removeFirst()
            }
            aPhotos.forEach { (imgUrl) in
                let imageView = UIImageView()
                imageView.image = IMGPLACEHOLDER
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                contentView?.addSubview(imageView)
                
                imageView.snp.makeConstraints({
                    $0.top.equalTo(topItem.snp.bottom)
                    $0.centerX.equalTo(topItem)
                    $0.width.equalTo(KEYSCREEN_W)
                    $0.height.equalTo(KEYSCREEN_W)
                })
                topItem = imageView
                
                imageView.kf.setImage(with: imgUrl.url, placeholder: imageView.image, completionHandler: { (result) in
                    if case .success(let data) = result {
                        let height = data.image.size.height*KEYSCREEN_W/data.image.size.width
                        imageView.snp.updateConstraints({
                            $0.height.equalTo(height)
                        })
                    }
                })
            }
        }
        
        contentView?.snp.makeConstraints({
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalTo(topItem.snp.bottom).offset(20)
        })
    }
    
    func updateUI() {
        switch viewType {
        case .video:
            numCount?.text = ""
        case .images:
            numCount?.text = "1/\(photos.count)"
        }
    }
    
    func openPhotoBrowser(pageIndex: Int) {
        /// 数字标识器代理
        let delegate = NumberPageControl { [weak self] (index, type, isDiss, time) in
            guard let `self` = self else { return }
            self.collect?.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
            if let t = time {
                self.seekTime = t
            }
            if isDiss, type == .video, index == 0 {
                self.playAction()
            }
        }
        delegate.viewType = viewType
        delegate.videoUrl = (productModel.video ?? "").url
        delegate.seekTime = seekTime
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
        let dataSource = JXNetworkingDataSource(photoLoader: JXKingfisherLoader(), numberOfItems: { [weak self] () -> Int in
            guard let `self` = self else { return 0 }
            return self.photos.count
            }, placeholder: { (_) -> UIImage? in
                return IMGPLACEHOLDER
        }) { [weak self] (index) -> String? in
            guard let `self` = self else { return nil }
            return self.photos[index]
        }
        /// 场景转换
        let trans = JXPhotoBrowserZoomTransitioning { (_, _, _) -> CGRect? in
            return CGRect(x: 0, y: 0, width: KEYSCREEN_W, height: KEYSCREEN_W)
        }
        JXPhotoBrowser(dataSource: dataSource, delegate: delegate, transDelegate: trans).show(pageIndex: pageIndex)
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
    
    @objc func playAction() {
        collect?.addSubview(player)
        player.snp.remakeConstraints {
            $0.top.left.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        switch player.status {
        case .playing:
            break
        case .paused:
            player.play()
        case .none:
            if let url = (productModel.video ?? "").url {
                player.play(url: url)
                player.seek(to: seekTime)
            }
        }
        player.viewStatus = .cover
        player.clickCover { [weak self] in
            guard let `self` = self else { return }
            self.openPhotoBrowser(pageIndex: 0)
            DispatchQueue.main.asyncAfter(wallDeadline: .now()+0.25, execute: {
                self.player.stop()
            })
        }
        player.periodicTime { [weak self] (time) in
            guard let `self` = self else { return }
            self.seekTime = time
        }
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
    
    @objc func gotoFactory() {
        if let eid = productModel.eid {
            viewModel.enterpriseById(id: eid) { [weak self] (result) in
                if case .success = result {                
                    guard let `self` = self else { return }
                    let vc = LTFactroyDetailController()
                    vc.detailModel = self.viewModel.detailModel
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewType == .video {        
            playAction()
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

extension LTProductDetailsController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LTDetailsPhotoCell.self), for: indexPath)
        if let iCell = cell as? LTDetailsPhotoCell {
            iCell.imageView?.kf.setImage(with: photos[indexPath.item].url, placeholder: IMGPLACEHOLDER)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let y = scroll?.contentOffset.y, y > 0 {
            return
        }
        if viewType == .video, indexPath.item == 0 {
            return
        }
        openPhotoBrowser(pageIndex: indexPath.item)
        player.stop()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == scroll {
            view.layoutIfNeeded()
            if let topH = topView?.frame.height, let navH = navBar?.frame.height {
                let scale = (scrollView.contentOffset.y-(KEYSCREEN_W-topH-navH)+topH+navH)/(topH+navH)
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
            if scrollView.contentOffset.y < 0 {
                transView?.frame = CGRect(x: 0, y: scrollView.contentOffset.y, width: KEYSCREEN_W, height: KEYSCREEN_W-scrollView.contentOffset.y)
                transView?.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            } else {
                let scale = scrollView.contentOffset.y/KEYSCREEN_W
                transView?.backgroundColor = UIColor.black.withAlphaComponent(0.5*scale+0.1)
                transView?.frame = CGRect(x: 0, y: 0, width: KEYSCREEN_W, height: KEYSCREEN_W)
            }
        }
        if scrollView == collect {
            switch viewType {
            case .video:
                if Int((scrollView.contentOffset.x+KEYSCREEN_W/2)/KEYSCREEN_W) < 1 {
                    if player.status == .paused {
                        player.play()
                    }
                    numCount?.text = ""
                    videoFlag?.backgroundColor = LTTheme.select
                    videoFlag?.textColor = UIColor.white
                    imageFlag?.backgroundColor = UIColor.white
                    imageFlag?.textColor = UIColor.darkGray
                } else {
                    if player.status == .playing {
                        player.pause()
                    }
                    videoFlag?.backgroundColor = UIColor.white
                    videoFlag?.textColor = UIColor.darkGray
                    imageFlag?.backgroundColor = LTTheme.select
                    imageFlag?.textColor = UIColor.white
                    numCount?.text = "\(Int((scrollView.contentOffset.x+KEYSCREEN_W/2)/KEYSCREEN_W))/\(photos.count-1)"
                }
            case .images:
                numCount?.text = "\(Int((scrollView.contentOffset.x+KEYSCREEN_W/2)/KEYSCREEN_W)+1)/\(photos.count)"
            }
            scroll?.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
}

