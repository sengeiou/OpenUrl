//
//  LTHomeViewController.swift
//  coolPer
//
//  Created by LangTe on 2019/7/5.
//  Copyright © 2019 LangTe. All rights reserved.
//

import UIKit
import YYFast

struct ItemSouce {
    init(title: String, image: UIImage, rgb: UIColor, itemWidth: CGFloat, itemHeight: CGFloat) {
        self.title = title
        self.itemWidth = itemWidth
        self.itemHeight = itemHeight
        self.image = image
        self.bgColor = rgb
    }
    var bgColor: UIColor
    var image: UIImage
    var title: String
    var frame: CGRect = CGRect.zero
    var itemWidth: CGFloat
    var itemHeight: CGFloat
}

class LTHomeViewController: LTViewController {
    var collectView: LTCollectionView?
    lazy var source: [ItemSouce] = {
        let itemSize1: CGFloat = (KEYSCREEN_W-50)/4
        let itemSize2: CGFloat = (KEYSCREEN_W-40)/3
        let sources = [
            ItemSouce(title: "查找手机", image: #imageLiteral(resourceName: "found_phone"), rgb: RGB(245, 190, 99), itemWidth: itemSize1, itemHeight: itemHeight),
            ItemSouce(title: "睡眠监测", image: #imageLiteral(resourceName: "sleep"), rgb: RGB(255, 143, 214), itemWidth: itemSize1, itemHeight: itemHeight),
            ItemSouce(title: "跑步", image: #imageLiteral(resourceName: "run"), rgb: RGB(97, 194, 223), itemWidth: itemSize1*2+10, itemHeight: itemHeight*2+10),
            ItemSouce(title: "心率", image: #imageLiteral(resourceName: "heart_rate"), rgb: RGB(252, 149, 158), itemWidth: itemSize1, itemHeight: itemHeight),
            ItemSouce(title: "血压", image: #imageLiteral(resourceName: "heart_pressure"), rgb: RGB(207, 143, 238), itemWidth: itemSize1, itemHeight: itemHeight),
            ItemSouce(title: "微聊", image: #imageLiteral(resourceName: "micro_talk"), rgb: RGB(67, 210, 130), itemWidth: itemSize2, itemHeight: itemHeight),
            ItemSouce(title: "拍照", image: #imageLiteral(resourceName: "camera"), rgb: RGB(251, 155, 163), itemWidth: itemSize2, itemHeight: itemHeight),
            ItemSouce(title: "酷跑圈", image: #imageLiteral(resourceName: "club"), rgb: RGB(234, 174, 133), itemWidth: itemSize2, itemHeight: itemHeight),
            ItemSouce(title: "防走丢", image: #imageLiteral(resourceName: "anti_lost"), rgb: RGB(194, 97, 255), itemWidth: itemSize2, itemHeight: itemHeight),
            ItemSouce(title: "消息提醒", image: #imageLiteral(resourceName: "notice"), rgb: RGB(238, 143, 203), itemWidth: itemSize2, itemHeight: itemHeight),
            ItemSouce(title: "我的", image: #imageLiteral(resourceName: "man"), rgb: RGB(82, 191, 162), itemWidth: itemSize2, itemHeight: itemHeight),
            ItemSouce(title: "商城", image: #imageLiteral(resourceName: "market"), rgb: RGB(251, 105, 105), itemWidth: itemSize2, itemHeight: itemHeight),
            ItemSouce(title: "我的定位", image: #imageLiteral(resourceName: "local"), rgb: RGB(245, 190, 99), itemWidth: itemSize2, itemHeight: itemHeight),
            ItemSouce(title: "闹钟", image: #imageLiteral(resourceName: "alarm"), rgb: RGB(207, 143, 238), itemWidth: itemSize2, itemHeight: itemHeight),
            ItemSouce(title: "地图", image: #imageLiteral(resourceName: "map"), rgb: RGB(128, 201, 239), itemWidth: itemSize1*2+10, itemHeight: itemHeight),
            ItemSouce(title: "设置", image: #imageLiteral(resourceName: "setting"), rgb: RGB(164, 163, 168), itemWidth: itemSize1*2+10, itemHeight: itemHeight)
        ]
        return sources
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "酷跑"
        
        collectView = LTCollectionView(frame: .zero, collectionViewLayout: LTHomeItemLayout())
        collectView?.itemSource = source
        collectView?.itemSpace = 10
        collectView?.topInset = 200
        view.addSubview(collectView!)
        
        collectView?.clickHomeItem({ [weak self] (index) in
            guard let `self` = self else { return }
            self.clickItem(index)
        })
                
        collectView?.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })

        let banner = LTBanner(frame: CGRect(x: 0, y: 0, width: KEYSCREEN_W, height: 200))
        banner.images = [
            BannerItem(image: #imageLiteral(resourceName: "place"), title: ""),
            BannerItem(image: #imageLiteral(resourceName: "place"), title: ""),
            BannerItem(image: #imageLiteral(resourceName: "place"), title: ""),
            BannerItem(image: #imageLiteral(resourceName: "place"), title: "")
        ]
        banner.clickCurrentPage {
            print($0)
            self.present(LTNavigationController(rootViewController: LTLoginViewController()), animated: true)
        }
        collectView?.addSubview(banner)
    }
    
    func clickItem(_ index: Int) {
        switch source[index].title {
        case "查找手机":
            let vc = LTFindPhoneViewController()
            vc.title = source[index].title
            navigationController?.pushViewController(vc, animated: true)
        case "睡眠监测":
            let vc = LTSleepViewController()
            vc.title = "睡眠"
            navigationController?.pushViewController(vc, animated: true)
        case "跑步":
            let vc = LTRuningViewController()
            vc.title = source[index].title
            navigationController?.pushViewController(vc, animated: true)
        case "心率":
            let vc = LTXinLvController()
            vc.title = source[index].title
            navigationController?.pushViewController(vc, animated: true)
        case "血压":
            let vc = LTXueYaController()
            vc.title = source[index].title
            navigationController?.pushViewController(vc, animated: true)
        case "拍照":
            let vc = LTPhotographController()
            vc.title = source[index].title
            navigationController?.pushViewController(vc, animated: true)
        case "防走丢":
            let vc = LTLostViewController()
            vc.title = source[index].title
            navigationController?.pushViewController(vc, animated: true)
        case "消息提醒":
            let vc = LTMessageViewController()
            vc.title = source[index].title
            navigationController?.pushViewController(vc, animated: true)
        case "我的定位":
            let vc = LTLocalViewController()
            vc.title = source[index].title
            navigationController?.pushViewController(vc, animated: true)
        case "商城":
            let vc = LTShopViewController()
            vc.title = source[index].title
            navigationController?.pushViewController(vc, animated: true)
        case "酷跑圈":
            let vc = LTRunLineViewController()
            vc.title = source[index].title
            navigationController?.pushViewController(vc, animated: true)
        case "我的":
            let vc = LTMeViewController()
            vc.title = source[index].title
            navigationController?.pushViewController(vc, animated: true)
        case "闹钟":
            let vc = LTAlarmViewController()
            vc.title = source[index].title
            navigationController?.pushViewController(vc, animated: true)
        case "设置":
            let vc = LTSetUpViewController()
            vc.title = source[index].title
            navigationController?.pushViewController(vc, animated: true)
        case "地图":
            let vc = LTMapController()
            vc.title = source[index].title
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = LTTheme.navBG
        navigationController?.navigationBar.shadowImage = nil
    }
}

