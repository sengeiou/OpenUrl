//
//  LTBanner.swift
//  cameraman
//
//  Created by haozhiyu on 2019/3/13.
//  Copyright © 2019 haozhiyu. All rights reserved.
//

import UIKit
import YYFast
import SnapKit
import Kingfisher

struct BannerItem {
    var image: ImageSource
    var title: String
}

protocol ImageSource {
    var imageUrl: String? { get }
    var image: UIImage? { get }
}

extension ImageSource {
    var imageUrl: String? {
        return nil
    }
    
    var image: UIImage? {
        return nil
    }
}

extension UIImage: ImageSource {    
    var image: UIImage? {
        return self
    }
}

extension String: ImageSource {
    var imageUrl: String? {
        return self
    }
}

class LTBanner: UIView {
    var repeatime: Double = 5
    var images: [BannerItem]? {
        didSet {
            configData()
        }
    }
    private var banner: UICollectionView!
    private var control: UIPageControl!
    private var timer: DispatchSourceTimer?
    private var datas: [BannerItem]?
    private var clickBlock: ((Int)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = frame.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        banner = UICollectionView(frame: bounds, collectionViewLayout: layout)
        banner.backgroundColor = UIColor.clear
        banner.isPagingEnabled = true
        banner.showsHorizontalScrollIndicator = false
        banner.delegate = self
        banner.dataSource = self
        banner.register(BannerCell.self, forCellWithReuseIdentifier: String(describing: BannerCell.self))
        addSubview(banner)
        
        control = UIPageControl()
        control.isUserInteractionEnabled = false
        addSubview(control)
        control.hidesForSinglePage = true
        control.currentPageIndicatorTintColor = LTTheme.navBG
        control.pageIndicatorTintColor = UIColor.white
    }
    
    private func configData() {
        guard let data = images else { return }
        datas = data
        if let first = data.first, let last = data.last {
            datas?.append(first)
            datas?.insert(last, at: 0)
            banner.reloadData()
            banner.contentOffset.x = banner.bounds.width
        }
        control.numberOfPages = data.count
        control.sizeToFit()
        control.center.x = bounds.width/2
        control.frame.origin.y = bounds.height-control.frame.height
        start()
    }
    
    func clickCurrentPage(_ block:@escaping (Int)->()) {
        clickBlock = block
    }
    
    private func start() {
        guard let data = images else { return }
        if data.count <= 1 {
            return
        }
        
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer?.schedule(wallDeadline: .now()+repeatime, repeating: repeatime, leeway: .milliseconds(1))
        timer?.setEventHandler { [weak self] in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.dumpPage()
            }
        }
        timer?.resume()
    }
    
    private func dumpPage() {
        banner.setContentOffset(CGPoint(x: banner.contentOffset.x+banner.bounds.width, y: banner.contentOffset.y), animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer?.cancel()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

extension LTBanner: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BannerCell.self), for: indexPath)
        if let cells = cell as? BannerCell, let aDatas = datas {
            cells.item = aDatas[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clickBlock?(indexPath.item-1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == banner {
            guard let imageDatas = datas else { return }
            var currentPage = Int((scrollView.contentOffset.x+banner.bounds.width/2)/banner.bounds.width)-1
            if currentPage < 0 {
                currentPage = control.numberOfPages-1
            } else if currentPage >= control.numberOfPages {
                currentPage = 0
            }
            control.currentPage = currentPage
            if scrollView.contentOffset.x <= 0 {
                scrollView.contentOffset.x = banner.bounds.width*CGFloat(imageDatas.count-2)
            }
            if scrollView.contentOffset.x >= banner.bounds.width*CGFloat(imageDatas.count-1) {
                scrollView.contentOffset.x = banner.bounds.width
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == banner {
            scrollView.contentOffset.x = CGFloat(Int(scrollView.contentOffset.x/banner.bounds.width))*banner.bounds.width
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == banner {
            timer?.cancel()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == banner {
            start()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == banner, !decelerate {
            start()
        }
    }
}

class BannerCell: UICollectionViewCell {
    var title: UILabel!
    var imageView: UIImageView!
    var item: BannerItem? {
        didSet {
            upDataModel()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { 
            $0.edges.equalToSuperview()
        }
        
        title = UILabel()
        title.isHidden = true
        contentView.addSubview(title)
        
        title.snp.makeConstraints { 
            $0.center.equalToSuperview()
        }
    }
    
    func upDataModel() {
        guard let data = item else {
            imageView.image = #imageLiteral(resourceName: "Alert_warning")
            title.text = ""
            return
        }
        
        if let image = data.image.image {
            imageView.image = image
        }
        
        if let imageUrl = data.image.imageUrl {
            imageView.kf.setImage(with: URL(string: imageUrl), placeholder: #imageLiteral(resourceName: "Alert_warning"))
        }
        
        title.text = data.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
