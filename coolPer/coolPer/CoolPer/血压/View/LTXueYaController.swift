//
//  LTXueYaController.swift
//  coolPer
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
//  Created by LonTe on 2019/10/11.
//  Copyright © 2019 LangTe. All rights reserved.
//


import UIKit
import AAInfographics
import HGCircularSlider

class LTXueYaController: LTViewController {
    enum ViewType {
        case ring
        case line
    }
    var collect: UICollectionView!
    var bgView: UIView!
    var viewType: ViewType = .ring
    var line: AAChartView!
    let xueYaData = [
        ["时间", "高压", "低压", "压差"],
        ["01:30", "135", "70", "60"],
        ["02:30", "135", "70", "60"],
        ["03:30", "135", "70", "60"],
        ["04:30", "135", "70", "60"],
        ["05:30", "135", "70", "60"],
        ["06:30", "135", "70", "60"],
        ["07:30", "135", "70", "60"],
        ["08:30", "135", "70", "60"],
        ["09:30", "135", "70", "60"],
        ["10:30", "135", "70", "60"],
        ["11:30", "135", "70", "60"],
        ["12:30", "135", "70", "60"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: .plain, target: self, action: #selector(shareAction))

        addViews()
    }
    
    func addViews() {
        bgView = UIView(frame: CGRect(x: 0, y: 0, width: KEYSCREEN_W, height: KEYSCREEN_W))
        bgView.backgroundColor = LTTheme.xueYaBg
        view.addSubview(bgView)
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        collect = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collect.delegate = self
        collect.dataSource = self
        collect.alwaysBounceVertical = true
        collect.backgroundColor = .clear
        let insetH = KEYSCREEN_W+110
        collect.contentInset.top = insetH
        collect.contentInset.bottom = 50
        
        if viewType == .ring {
            layout.itemSize = CGSize(width: (KEYSCREEN_W-31)/4, height: 44)
            collect.register(LTXueYaViewCell.self, forCellWithReuseIdentifier: String(describing: LTXueYaViewCell.self))
            view.addSubview(collect)
            
            collect.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            let chartView = UIView(frame: CGRect(x: 0, y: -insetH, width: KEYSCREEN_W, height: insetH))
            chartView.backgroundColor = LTTheme.xueYaBg
            collect.addSubview(chartView)
        
            let tap = UITapGestureRecognizer(target: self, action: #selector(gotoLineType))
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
            
            slider.maximumValue = 200
            slider.startPointValue = 30
            slider.endPointValue = 105
            slider.numberOfRounds = 2
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
            
            let xueYaImg = UIImageView(image: #imageLiteral(resourceName: "blood_presssure_icon"))
            centerView.addSubview(xueYaImg)
            
            xueYaImg.snp.makeConstraints {
                $0.size.equalTo(xueYaImg.image!.size)
                $0.top.centerX.equalToSuperview()
            }
            
            let hight = UILabel()
            hight.text = "高压118mmhg"
            hight.textColor = .white
            hight.font = UIFont.systemFont(ofSize: 26)
            centerView.addSubview(hight)
            
            hight.snp.makeConstraints {
                $0.top.equalTo(xueYaImg.snp.bottom)
                $0.centerX.equalToSuperview()
                $0.left.right.equalToSuperview()
            }
            
            let low = UILabel()
            low.text = "低压70mmhg"
            low.textColor = .white
            low.font = hight.font
            centerView.addSubview(low)
            
            low.snp.makeConstraints {
                $0.top.equalTo(hight.snp.bottom).offset(10)
                $0.centerX.equalToSuperview()
            }
            
            let status = UILabel()
            status.text = "理想血压"
            status.textColor = .white
            status.font = hight.font
            centerView.addSubview(status)
            
            status.snp.makeConstraints {
                $0.top.equalTo(low.snp.bottom).offset(10)
                $0.centerX.bottom.equalToSuperview()
            }
            
            centerView.snp.makeConstraints {
                $0.center.equalTo(slider)
            }
            
            let goTest = UIButton(type: .custom)
            goTest.setTitle("开始测量血压", for: .normal)
            goTest.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            goTest.setTitleColor(.white, for: .normal)
            goTest.setTitleColor(LTTheme.xueYaBg, for: .highlighted)
            goTest.setBackgroundImage(LTTheme.xueYaBg.image, for: .normal)
            goTest.setBackgroundImage(UIColor.white.image, for: .highlighted)
            goTest.layer.borderColor = UIColor.white.cgColor
            goTest.layer.borderWidth = 2
            goTest.layer.cornerRadius = KEYSCREEN_W/2/4/2
            goTest.layer.masksToBounds = true
            chartView.addSubview(goTest)
            
            goTest.addTarget(self, action: #selector(testXueYa), for: .touchUpInside)

            goTest.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(slider.snp.bottom).offset(10)
                $0.width.equalTo(KEYSCREEN_W/2)
                $0.height.equalTo(goTest.snp.width).dividedBy(4)
            }
        } else {
            layout.itemSize = CGSize(width: KEYSCREEN_W, height: 240)
            collect.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
            view.addSubview(collect)
            
            collect.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            let chartView = UIView(frame: CGRect(x: 0, y: -insetH, width: KEYSCREEN_W, height: insetH))
            chartView.backgroundColor = LTTheme.xueYaBg
            collect.addSubview(chartView)
            
            let segment = UISegmentedControl(items: ["周", "月", "年"])
            segment.tintColor = UIColor.white
            segment.selectedSegmentIndex = 0
            segment.setTitleTextAttributes([.foregroundColor : LTTheme.xueYaBg], for: .selected)
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
                $0.width.equalTo(KEYSCREEN_W-100)
            }
            
            line = AAChartView()
            line.isClearBackgroundColor = true
            chartView.addSubview(line)
            
            line.snp.makeConstraints {
                $0.width.equalTo(KEYSCREEN_W)
                $0.centerX.equalToSuperview()
                $0.top.equalTo(segment.snp.bottom)
                $0.bottom.equalToSuperview()
            }
            var data = [Double]()
            for _ in 0..<50 {
                data.append(Double(arc4random()%20)/10-1)
            }
            
            let chartModel = AAChartModel()
                .chartType(.spline)//图表类型
                .title(" ")
                .inverted(false)//是否翻转图形
                .legendEnabled(false)//是否启用图表的图例(图表底部的可点击的小圆点)
                .colorsTheme([AAColor.white])//主题颜色数组
                .backgroundColor(AAColor.clear)
                .xAxisVisible(false)
                .dataLabelsEnabled(false)
                .axesTextColor(AAColor.white)
                .markerRadius(0)
                .series([
                    AASeriesElement()
                        .name("")
                        .data(data)
                        ])
             
            // 图表视图对象调用图表模型对象,绘制最终图形
            line.aa_drawChartWithChartModel(chartModel)
        }
    }
    
    @objc func topItemChang(_ segment: UISegmentedControl) {
        var data = [Double]()
        for _ in 0..<50 {
            data.append(Double(arc4random()%20)/10-1)
        }
        switch segment.selectedSegmentIndex {
        case 0:
            let series = AASeriesElement()
                .name("")
                .data(data)
            line.aa_onlyRefreshTheChartDataWithChartModelSeries([series.toDic()!])
        case 1:
            let series = AASeriesElement()
                .name("")
                .data(data)
            line.aa_onlyRefreshTheChartDataWithChartModelSeries([series.toDic()!])
        case 2:
            let series = AASeriesElement()
                .name("")
                .data(data)
            line.aa_onlyRefreshTheChartDataWithChartModelSeries([series.toDic()!])
        default:
            break
        }
    }
    
    @objc func gotoLineType() {
        if viewType == .ring {
            let vc = LTXueYaController()
            vc.title = "血压"
            vc.viewType = .line
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func shareAction() {
        
    }
    
    @objc func testXueYa() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = LTTheme.xueYaBg
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

extension LTXueYaController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if viewType == .ring {
            return xueYaData.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewType == .ring {
            return xueYaData[section].count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewType == .ring {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LTXueYaViewCell.self), for: indexPath)
            if let c = cell as? LTXueYaViewCell {
                c.value = xueYaData[indexPath.section][indexPath.item]
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self), for: indexPath)
            cell.contentView.removeAllSubviews()

            let centerView = UIView()
            cell.contentView.addSubview(centerView)
            
            let low = UILabel()
            low.text = "最低"
            centerView.addSubview(low)
            
            let lowText = UILabel()
            lowText.text = "55"
            lowText.font = UIFont.boldSystemFont(ofSize: 42)
            centerView.addSubview(lowText)
            
            low.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.centerX.equalTo(lowText)
            }
            
            lowText.snp.makeConstraints {
                $0.left.bottom.equalToSuperview()
                $0.top.equalTo(low.snp.bottom).offset(10)
            }
            
            let hight = UILabel()
            hight.text = "最高"
            centerView.addSubview(hight)
            
            let hightText = UILabel()
            hightText.text = "135"
            hightText.font = lowText.font
            centerView.addSubview(hightText)
            
            hight.snp.makeConstraints {
                $0.centerY.equalTo(low)
                $0.centerX.equalTo(hightText)
            }
            
            hightText.snp.makeConstraints {
                $0.left.equalTo(lowText.snp.right).offset(40)
                $0.centerY.equalTo(lowText)
            }
            
            let avg = UILabel()
            avg.text = "平均"
            centerView.addSubview(avg)
            
            let avgText = UILabel()
            avgText.text = "95"
            avgText.font = lowText.font
            centerView.addSubview(avgText)
            
            avg.snp.makeConstraints {
                $0.centerY.equalTo(low)
                $0.centerX.equalTo(avgText)
            }
            
            avgText.snp.makeConstraints {
                $0.centerY.equalTo(lowText)
                $0.left.equalTo(hightText.snp.right).offset(40)
                $0.right.equalToSuperview()
            }
            
            centerView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(80)
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if viewType == .ring {
            return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
        return .zero
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let insetH = KEYSCREEN_W+110
        if scrollView.contentOffset.y+insetH > 0 {
            bgView.frame.origin.y = -scrollView.contentOffset.y-insetH
        } else {
            bgView.frame.origin.y = 0
            bgView.frame.size.height = -scrollView.contentOffset.y
        }
    }
}


