//
//  LTRuningViewController.swift
//  coolPer
//
//  Created by LonTe on 2019/7/11.
//  Copyright © 2019 LangTe. All rights reserved.
//

import UIKit
import YYFast
import HGCircularSlider
import AAInfographics

class LTRuningViewController: LTViewController {
    enum ViewType {
        case ring
        case bar
    }
    var collect: UICollectionView!
    var bgView: UIView!
    var ringObj: [LTRuningCollectionViewCell.ItemObject]?
    var barObj: [LTRuningBarCell.ItemObject]?
    var viewType: ViewType = .ring
    var bar: AAChartView!
    var chartModel: AAChartModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: .plain, target: self, action: #selector(shareAction))

        addViews()
    }
    
    func addViews() {
        bgView = UIView(frame: CGRect(x: 0, y: 0, width: KEYSCREEN_W, height: KEYSCREEN_W))
        bgView.backgroundColor = LTTheme.runingBG
        view.addSubview(bgView)
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .zero
        
        if viewType == .ring {
            layout.itemSize = CGSize(width: (KEYSCREEN_W-1)/3, height: 90)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            collect = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collect.delegate = self
            collect.dataSource = self
            collect.alwaysBounceVertical = true
            collect.backgroundColor = .clear
            collect.register(LTRuningCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: LTRuningCollectionViewCell.self))
            let insetH = KEYSCREEN_W+110
            collect.contentInset.top = insetH
            collect.contentInset.bottom = 50
            view.addSubview(collect)
            
            collect.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            let chartView = UIView(frame: CGRect(x: 0, y: -insetH, width: KEYSCREEN_W, height: insetH))
            chartView.backgroundColor = LTTheme.runingBG
            collect.addSubview(chartView)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(goToBarViewType))
            chartView.addGestureRecognizer(tap)
            
            // 表的滑块
            let slider = RangeCircularSlider()
            slider.backgroundColor = .clear
            chartView.addSubview(slider)
            slider.lineWidth = 15
            slider.backtrackLineWidth = 15
            slider.diskColor = .clear
            slider.trackColor = UIColor(white: 1, alpha: 0.5)
            slider.trackFillColor = .white
            slider.startThumbImage = UIImage()
            slider.endThumbImage = UIImage()
            
            slider.maximumValue = 50000
            slider.startPointValue = 0
            slider.endPointValue = 40000
            slider.isEnabled = false
            
            // 时间
            let time = UILabel()
            let dataFormatter = DateFormatter()
            dataFormatter.dateFormat = "yyyy-MM-dd"
            time.text = dataFormatter.string(from: Date())
            time.font = UIFont.boldSystemFont(ofSize: 22)
            time.textColor = .white
            chartView.addSubview(time)
            
            time.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().inset(20)
            }
            
            slider.snp.makeConstraints {
                $0.right.left.equalToSuperview().inset(15)
                $0.top.equalTo(time.snp.bottom).offset(10)
                $0.height.equalTo(KEYSCREEN_W-15*2)
            }
            
            // 中间
            let centerView = UIView()
            chartView.addSubview(centerView)
            
            let runImg = UIImageView(image: #imageLiteral(resourceName: "run_icon"))
            runImg.contentMode = .scaleAspectFit
            centerView.addSubview(runImg)
            
            runImg.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(runImg.image!.size.width*2)
            }
            
            let runed = UILabel()
            runed.text = "40000步数"
            runed.textColor = .white
            runed.font = UIFont.boldSystemFont(ofSize: 20)
            centerView.addSubview(runed)
            
            runed.snp.makeConstraints {
                $0.top.equalTo(runImg.snp.bottom)
                $0.centerX.equalTo(runImg)
            }
            
            let runNum = UILabel()
            runNum.text = "目标50000步"
            runNum.textColor = runed.textColor
            runNum.font = runed.font
            centerView.addSubview(runNum)
            
            runNum.snp.makeConstraints {
                $0.top.equalTo(runed.snp.bottom).offset(15)
                $0.centerX.equalTo(runImg)
            }
            
            let didSuccess = UILabel()
            didSuccess.text = "完成度80%"
            didSuccess.textColor = runed.textColor
            didSuccess.font = runed.font
            centerView.addSubview(didSuccess)
            
            didSuccess.snp.makeConstraints {
                $0.top.equalTo(runNum.snp.bottom).offset(15)
                $0.centerX.equalTo(runImg)
            }
            
            centerView.snp.makeConstraints {
                $0.center.equalTo(slider)
                $0.bottom.equalTo(didSuccess)
                $0.width.equalToSuperview()
            }
            
            // 左边
            let leftView = UIView()
            chartView.addSubview(leftView)
            
            let localImg = UIImageView(image: #imageLiteral(resourceName: "location_icon"))
            leftView.addSubview(localImg)
            
            localImg.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview()
                $0.size.equalTo(localImg.image!.size)
            }
            
            let leftTop = UILabel()
            leftTop.text = "本周里程"
            leftTop.textColor = .white
            leftTop.font = UIFont.boldSystemFont(ofSize: 22)
            leftView.addSubview(leftTop)
            
            leftTop.snp.makeConstraints {
                $0.left.equalTo(localImg.snp.right).offset(5)
                $0.top.equalToSuperview()
                $0.right.equalToSuperview()
            }
            
            let leftBottom = UILabel()
            leftBottom.text = "1.5km"
            leftBottom.textColor = .white
            leftBottom.font = leftTop.font
            leftView.addSubview(leftBottom)
            
            leftBottom.snp.makeConstraints {
                $0.top.equalTo(leftTop.snp.bottom).offset(5)
                $0.centerX.equalTo(leftTop)
                $0.bottom.equalToSuperview()
            }
            
            leftView.snp.makeConstraints {
                $0.top.equalTo(slider.snp.bottom).offset(10)
                $0.centerX.equalToSuperview().offset(-KEYSCREEN_W/4)
            }
            
            // 右边
            let rightView = UIView()
            chartView.addSubview(rightView)
            
            let rightImg = UIImageView(image: #imageLiteral(resourceName: "run_icon"))
            rightView.addSubview(rightImg)
            
            rightImg.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview()
                $0.size.equalTo(rightImg.image!.size)
            }
            
            let rightTop = UILabel()
            rightTop.text = "本周步数"
            rightTop.textColor = .white
            rightTop.font = UIFont.boldSystemFont(ofSize: 22)
            rightView.addSubview(rightTop)
            
            rightTop.snp.makeConstraints {
                $0.left.equalTo(rightImg.snp.right).offset(5)
                $0.top.equalToSuperview()
                $0.right.equalToSuperview()
            }
            
            let rightBottom = UILabel()
            rightBottom.text = "30000步"
            rightBottom.textColor = .white
            rightBottom.font = rightTop.font
            rightView.addSubview(rightBottom)
            
            rightBottom.snp.makeConstraints {
                $0.top.equalTo(rightTop.snp.bottom).offset(5)
                $0.centerX.equalTo(rightTop)
                $0.bottom.equalToSuperview()
            }
            
            rightView.snp.makeConstraints {
                $0.top.equalTo(slider.snp.bottom).offset(10)
                $0.centerX.equalToSuperview().offset(KEYSCREEN_W/4-20)
            }
            
            ringObj = [
                LTRuningCollectionViewCell.ItemObject(title: "消耗能量", subTitle: "15KCL", image: #imageLiteral(resourceName: "run_hot")),
                LTRuningCollectionViewCell.ItemObject(title: "运动距离", subTitle: "0.5KM", image: #imageLiteral(resourceName: "run_distance")),
                LTRuningCollectionViewCell.ItemObject(title: "运动时间", subTitle: "0时35分", image: #imageLiteral(resourceName: "run_time")),
                LTRuningCollectionViewCell.ItemObject(title: "心率情况", subTitle: "75次/分", image: #imageLiteral(resourceName: "run_heart_ratet")),
                LTRuningCollectionViewCell.ItemObject(title: "连接状态", subTitle: "已连接", image: #imageLiteral(resourceName: "run_bluetooth")),
                LTRuningCollectionViewCell.ItemObject(title: "详细数据", subTitle: "", image: #imageLiteral(resourceName: "run_chart"))
            ]
        } else {
            layout.itemSize = CGSize(width: KEYSCREEN_W, height: 50)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            collect = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collect.delegate = self
            collect.dataSource = self
            collect.alwaysBounceVertical = true
            collect.backgroundColor = .clear
            collect.register(LTRuningBarCell.self, forCellWithReuseIdentifier: String(describing: LTRuningBarCell.self))
            let insetH = KEYSCREEN_W+110
            collect.contentInset.top = insetH
            collect.contentInset.bottom = 50
            view.addSubview(collect)
            
            collect.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            let chartView = UIView(frame: CGRect(x: 0, y: -insetH, width: KEYSCREEN_W, height: insetH))
            chartView.backgroundColor = LTTheme.runingBG
            collect.addSubview(chartView)
            
            let segment = UISegmentedControl(items: ["周", "月", "年", "总"])
            segment.tintColor = UIColor.white
            segment.selectedSegmentIndex = 0
            segment.setTitleTextAttributes([.foregroundColor : LTTheme.runingBG], for: .selected)
            segment.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
            if #available(iOS 13.0, *) {
                segment.layer.borderColor = UIColor.white.cgColor
                segment.layer.borderWidth = 1
            }
            chartView.addSubview(segment)
            
            segment.addTarget(self, action: #selector(topItemChang(_:)), for: .valueChanged)
            
            segment.snp.makeConstraints {
                $0.top.equalToSuperview().offset(10)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(40)
                $0.width.equalTo(KEYSCREEN_W-80)
            }
            
            bar = AAChartView()
            bar.isClearBackgroundColor = true
            chartView.addSubview(bar)
            
            bar.snp.makeConstraints {
                $0.width.equalTo(KEYSCREEN_W)
                $0.centerX.equalToSuperview()
                $0.top.equalTo(segment.snp.bottom).offset(10)
                $0.bottom.equalToSuperview()
            }
            
            chartModel = AAChartModel()
                .chartType(.column)
                .title(" ")
                .inverted(false)//是否翻转图形
                .legendEnabled(false)//是否启用图表的图例(图表底部的可点击的小圆点)
                .tooltipValueSuffix("步")
                .categories(["周一", "周二", "周三", "周四", "周五", "周六", "周日"])
                .axesTextColor(AAColor.white)
                .yAxisLabelsEnabled(false)
                .colorsTheme([
                    AAColor.rgbaColor(245, 190, 99, 1),
                    AAColor.rgbaColor(255, 143, 214, 1),
                    AAColor.rgbaColor(67, 210, 130, 1),
                    AAColor.rgbaColor(251, 105, 105, 1),
                    AAColor.rgbaColor(207, 143, 238, 1),
                    AAColor.rgbaColor(82, 191, 162, 1),
                    AAColor.rgbaColor(234, 174, 133, 1),
                              ])//主题颜色数组
                .backgroundColor(AAColor.clear)
                .series([
                    AASeriesElement()
                        .name("")
                        .colorByPoint(true)
                        .data([
                            ["周一", 5054],
                            ["周二", 8500],
                            ["周三", 8500],
                            ["周四", 5054],
                            ["周五", 8500],
                            ["周六", 8500],
                            ["周日", 5054]
                            ]),
                        ])
            bar.aa_drawChartWithChartModel(chartModel)
            
            barObj = [
                LTRuningBarCell.ItemObject(title: "消耗能量", subTitle: "15KCL", image: #imageLiteral(resourceName: "run_hot")),
                LTRuningBarCell.ItemObject(title: "心率情况", subTitle: "75次/分", image: #imageLiteral(resourceName: "run_heart_ratet")),
                LTRuningBarCell.ItemObject(title: "平均配速", subTitle: "200ms", image: #imageLiteral(resourceName: "run_chart_speed_average")),
                LTRuningBarCell.ItemObject(title: "平均时速", subTitle: "15km/h", image: #imageLiteral(resourceName: "run_chart_speed_hour"))
            ]
        }
    }
    
    @objc func topItemChang(_ segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            chartModel
                .inverted(false)//是否翻转图形
                .categories(["周一", "周二", "周三", "周四", "周五", "周六", "周日"])
                .series([
                    AASeriesElement()
                        .name("")
                        .colorByPoint(true)
                        .data([
                            ["周一", 5054],
                            ["周二", 1500],
                            ["周三", 2500],
                            ["周四", 3054],
                            ["周五", 5500],
                            ["周六", 8500],
                            ["周日", 7054]
                            ]),
                        ])
            bar.aa_refreshChartWholeContentWithChartModel(chartModel)
        case 1:
            chartModel
                .inverted(true)//是否翻转图形
                .categories(["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"])
                .series([
                    AASeriesElement()
                        .name("")
                        .colorByPoint(true)
                        .data([
                            ["一月", 1054],
                            ["二月", 2500],
                            ["三月", 6500],
                            ["四月", 3054],
                            ["五月", 9500],
                            ["六月", 8500],
                            ["七月", 5500],
                            ["八月", 8054],
                            ["九月", 2500],
                            ["十月", 1500],
                            ["十一月", 2054],
                            ["十二月", 9988]
                            ]),
                        ])
            bar.aa_refreshChartWholeContentWithChartModel(chartModel)
        case 2:
            chartModel
                .inverted(true)//是否翻转图形
                .categories(["2019年", "2018年", "2017年", "2016年", "2015年", "2014年", "2013年", "2012年", "2011年", "2010年"])
                .series([
                    AASeriesElement()
                        .name("")
                        .colorByPoint(true)
                        .data([
                            ["2019年", 9054],
                            ["2018年", 5500],
                            ["2017年", 4500],
                            ["2016年", 10054],
                            ["2015年", 5500],
                            ["2014年", 3500],
                            ["2013年", 11500],
                            ["2012年", 854],
                            ["2011年", 10500],
                            ["2010年", 9500]
                            ]),
                        ])
            bar.aa_refreshChartWholeContentWithChartModel(chartModel)
        case 3:
            chartModel
                .inverted(true)//是否翻转图形
                .categories(["周一", "周二", "周三", "周四", "周五", "周六", "周日", "一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月", "2019年", "2018年", "2017年", "2016年", "2015年", "2014年", "2013年", "2012年", "2011年", "2010年"])
                .series([
                    AASeriesElement()
                        .name("")
                        .colorByPoint(true)
                        .data([
                            ["周一", 5054],
                            ["周二", 1500],
                            ["周三", 2500],
                            ["周四", 3054],
                            ["周五", 5500],
                            ["周六", 8500],
                            ["周日", 7054],
                            ["一月", 1054],
                            ["二月", 2500],
                            ["三月", 6500],
                            ["四月", 3054],
                            ["五月", 9500],
                            ["六月", 8500],
                            ["七月", 5500],
                            ["八月", 8054],
                            ["九月", 2500],
                            ["十月", 1500],
                            ["十一月", 2054],
                            ["十二月", 9988],
                            ["2019年", 9054],
                            ["2018年", 5500],
                            ["2017年", 4500],
                            ["2016年", 10054],
                            ["2015年", 5500],
                            ["2014年", 3500],
                            ["2013年", 11500],
                            ["2012年", 854],
                            ["2011年", 10500],
                            ["2010年", 9500]
                            ]),
                        ])
            bar.aa_refreshChartWholeContentWithChartModel(chartModel)
        default:
            break
        }
    }
    
    @objc func shareAction() {
        
    }
    
    @objc func goToBarViewType() {
        let vc = LTRuningViewController()
        vc.title = "跑步"
        vc.viewType = .bar
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = LTTheme.runingBG
        navigationController?.navigationBar.shadowImage = UIImage()
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

extension LTRuningViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewType == .ring {
            return ringObj?.count ?? 0
        } else {
            return barObj?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewType == .ring {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LTRuningCollectionViewCell.self), for: indexPath)
            if let c = cell as? LTRuningCollectionViewCell {
                c.itemObj = ringObj?[indexPath.item]
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LTRuningBarCell.self), for: indexPath)
            if let c = cell as? LTRuningBarCell {
                c.itemObj = barObj?[indexPath.item]
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewType == .bar {
            return
        }
        if let obj = ringObj?[indexPath.item], obj.title == "详细数据" {
            let vc = LTRuningViewController()
            vc.title = "跑步"
            vc.viewType = .bar
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var insetH: CGFloat = 0
        if viewType == .ring {
            insetH = KEYSCREEN_W+110
        }
        if scrollView.contentOffset.y+insetH > 0 {
            bgView.frame.origin.y = -scrollView.contentOffset.y-insetH
        } else {
            bgView.frame.origin.y = 0
            bgView.frame.size.height = -scrollView.contentOffset.y
        }
    }
}
