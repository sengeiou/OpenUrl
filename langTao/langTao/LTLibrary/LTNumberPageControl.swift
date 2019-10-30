//
//  LTNumberPageControl.swift
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

class NumberPageControl: JXNumberPageControlDelegate {
    var viewType: LTProductDetailsController.DetailViewType = .images
    var videoUrl: URL?
    var seekTime: Double = 0

    private var pageBlock: ((Int, LTProductDetailsController.DetailViewType, Bool, Double?)->())?
    private var selectedSegmentIndex: Int = 0
    lazy private var player: YYPlayerView = {
        let player = YYPlayerView()
        return player
    }()
    lazy private var leftBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "deleteBar"), for: .normal)
        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return btn
    }()
    lazy private var topItem: UISegmentedControl = {
        let titles = ["video".localString, "picture".localString]
        let item = UISegmentedControl(items: titles)
        item.setTitleTextAttributes([.font : UIFont.systemFont(ofSize: 16), .foregroundColor : UIColor.white], for: .normal)
        item.setTitleTextAttributes([.font : UIFont.systemFont(ofSize: 16), .foregroundColor : UIColor.white], for: .selected)
        titles.enumerated().forEach({ (index, title) in
            let width = (title as NSString).boundingRect(with: CGSize(width: 0, height: 0), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font : UIFont.systemFont(ofSize: 16)], context: nil).size.width
            item.setWidth(width+20, forSegmentAt: index)
        })
        item.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        item.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        item.isMomentary = true
        item.apportionsSegmentWidthsByContent = true
        item.addTarget(self, action: #selector(topItemAction), for: .valueChanged)
        return item
    }()
    lazy private var line: UILabel = {
        let line = UILabel()
        line.backgroundColor = UIColor.green
        return line
    }()
    
    convenience init(pageIndexDidChanged block:@escaping ((Int, LTProductDetailsController.DetailViewType, Bool, Double?)->())) {
        self.init()
        pageBlock = block
    }
    
    override init() {
        super.init()
        font = UIFont.systemFont(ofSize: 13)
    }
    
    @objc private func topItemAction() {
        guard let browser = self.browser else { return }
        if topItem.selectedSegmentIndex == 0 {
            browser.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        } else {
            browser.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    private func playVideo() {
        guard let browser = self.browser else { return }
        browser.collectionView.addSubview(player)
        player.frame = CGRect(x: 0, y: 0, width: KEYSCREEN_W, height: KEYSCREEN_H)
        switch player.status {
        case .playing:
            player.muted(isMuted: false)
        case .paused:
            player.play()
            player.muted(isMuted: false)
        case .none:
            if let url = videoUrl {
                player.play(url: url)
                player.seek(to: seekTime)
            }
        }
        player.viewStatus = .real
        player.periodicTime { [weak self] (time) in
            guard let `self` = self else { return }
            self.seekTime = time
        }
    }
    
    override func photoBrowser(_ browser: JXPhotoBrowser, pageIndexDidChanged pageIndex: Int) {
        super.photoBrowser(browser, pageIndexDidChanged: pageIndex)
        if viewType == .video {
            if pageIndex != 0 {
                if player.status == .playing {
                    player.pause()
                    player.muted(isMuted: true)
                }
            } else {
                playVideo()
            }
            selectedSegmentIndex = browser.pageIndex != 0 ? 1 : 0
        }
        layout()
        pageBlock?(pageIndex, viewType, false, nil)
    }
    
    override func photoBrowser(_ browser: JXPhotoBrowser, viewDidAppear animated: Bool) {
        super.photoBrowser(browser, viewDidAppear: animated)
        if viewType == .video, browser.pageIndex == 0 {
            playVideo()
        } else {
            seekTime = 0
        }
    }
    
    override func photoBrowser(_ browser: JXPhotoBrowser, viewWillAppear animated: Bool) {
        super.photoBrowser(browser, viewWillAppear: animated)
        browser.view.addSubview(leftBtn)
        if viewType == .video {
            browser.view.addSubview(topItem)
            browser.view.addSubview(line)
            selectedSegmentIndex = browser.pageIndex != 0 ? 1 : 0
        }
    }
    
    override func transitionZoomView(_ browser: JXPhotoBrowser, pageIndex: Int) -> UIView? {
        if viewType == .video, browser.pageIndex == 0 {
            return player
        } else {
            return super.transitionZoomView(browser, pageIndex: pageIndex)
        }
    }
    
    override func photoBrowser(_ browser: JXPhotoBrowser, viewDidDisappear animated: Bool) {
        super.photoBrowser(browser, viewDidDisappear: animated)
        pageBlock?(browser.pageIndex, viewType, true, seekTime)
        if viewType == .video {
            player.stop()
        }
    }

    override func photoBrowserViewWillLayoutSubviews(_ browser: JXPhotoBrowser) {
        super.photoBrowserViewWillLayoutSubviews(browser)
        layout()
    }
    
    override func photoBrowserDidReloadData(_ browser: JXPhotoBrowser) {
        layout()
    }
    
    @objc private func dismiss() {
        if let photoBrowser = browser {
            dismissPhotoBrowser(photoBrowser)
        }
    }
    
    private func layout() {
        guard let browser = self.browser else {
            return
        }
        guard let superView = pageControl.superview else { return }
        let totalPages = browser.itemsCount
        
        switch viewType {
        case .video:
            pageControl.text = browser.pageIndex == 0 ? "" : "\(browser.pageIndex) / \(totalPages-1)"
        case .images:
            pageControl.text = "\(browser.pageIndex + 1) / \(totalPages)"
        }
        pageControl.sizeToFit()
        pageControl.center.x = superView.bounds.width / 2
        pageControl.frame.origin.y = KEYSCREEN_H-pageControl.frame.height-30
        pageControl.isHidden = totalPages <= 1
        
        leftBtn.frame.size.width = 44
        leftBtn.frame.size.height = 44
        leftBtn.frame.origin.x = 5
        leftBtn.frame.origin.y = UIDevice.current.isX() ? 44 : 20
        
        if viewType == .video {
            player.frame.origin.x = 0
            player.frame.origin.y = 0
            
            topItem.frame.size.height = 44
            topItem.frame.origin.y = UIDevice.current.isX() ? 44 : 20
            topItem.center.x = KEYSCREEN_W/2
            
            line.frame.size.width = topItem.widthForSegment(at: selectedSegmentIndex)-20
            line.frame.size.height = 3
            line.frame.origin.x = topItem.frame.minX+topItem.widthForSegment(at: 0)*CGFloat(selectedSegmentIndex)+10
            line.frame.origin.y = topItem.frame.maxY
        }
    }
}

