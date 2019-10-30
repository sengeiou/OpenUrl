//
//  LTSleepViewController.swift
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
//  Created by LonTe on 2019/10/8.
//  Copyright © 2019 LangTe. All rights reserved.
//


import UIKit
import HGCircularSlider
import AAInfographics

class LTSleepViewController: LTViewController {
    enum ViewType {
        case clock
        case bar
    }
    var bgView: UIView!
    var slider: RangeCircularSlider!
    var bedtimeLabel: UILabel!
    var wakeLabel: UILabel!
    var durationLabel: UILabel!
    var viewType: ViewType = .clock
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "ahh:mm"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: .plain, target: self, action: #selector(shareAction))
        addScroll()
    }
    
    func addScroll() {
        bgView = UIView(frame: CGRect(x: 0, y: 0, width: KEYSCREEN_W, height: KEYSCREEN_W))
        bgView.backgroundColor = LTTheme.sleepBG
        view.addSubview(bgView)
        
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        scroll.delegate = self
        view.addSubview(scroll)
        
        scroll.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let content = UIView()
        scroll.addSubview(content)
        
        // 表的父视图
        let chartView = LTChartView()
        chartView.backgroundColor = LTTheme.sleepBG
        chartView.scorll = scroll
        chartView.viewType = viewType
        content.addSubview(chartView)
        
        chartView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(KEYSCREEN_W)
        }
        
        if viewType == .clock {
            let tap = UITapGestureRecognizer(target: self, action: #selector(goToBarViewType))
            tap.delegate = self
            chartView.addGestureRecognizer(tap)

            chartView.snp.updateConstraints {
                $0.height.equalTo(KEYSCREEN_W+100)
            }
            // 刻度盘
            let clock = UIImageView(image: #imageLiteral(resourceName: "表盘"))
            chartView.addSubview(clock)
            
            // 表的滑块
            slider = RangeCircularSlider()
            slider.backgroundColor = .clear
            chartView.addSubview(slider)
            slider.lineWidth = 40
            slider.backtrackLineWidth = 40
            slider.diskColor = .clear
            slider.trackColor = RGB(222, 222, 222)
            slider.trackFillColor = RGB(135, 70, 249)
            slider.startThumbImage = #imageLiteral(resourceName: "sleep_light")
            slider.endThumbImage = #imageLiteral(resourceName: "sleep_asleep")
            slider.numberOfRounds = 2
            
            let dayInSeconds = 24 * 60 * 60
            slider.maximumValue = CGFloat(dayInSeconds)
            slider.startPointValue = 23 * 60 * 60
            slider.endPointValue = 7 * 60 * 60
            slider.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)

            slider.snp.makeConstraints {
                $0.right.left.bottom.equalToSuperview().inset(15)
                $0.height.equalTo(KEYSCREEN_W-15*2)
            }
            
            clock.snp.makeConstraints {
                $0.center.equalTo(slider)
                $0.width.height.equalTo(KEYSCREEN_W-15*2-40*2-20*2)
            }
            
            // 时间
            let time = UILabel()
            let dataFormatter = DateFormatter()
            dataFormatter.dateFormat = "yyyy-MM-dd"
            time.text = dataFormatter.string(from: Date())
            time.font = UIFont.boldSystemFont(ofSize: 22)
            time.textColor = .white
            content.addSubview(time)
            
            time.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().inset(20)
            }
            
            // 就寝
            let sleepView = UIView()
            content.addSubview(sleepView)
            let sleepImg = UIImageView(image: #imageLiteral(resourceName: "sleep_light"))
            sleepView.addSubview(sleepImg)

            sleepImg.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview()
                $0.size.equalTo(sleepImg.image!.size)
            }

            let sleepMsg = UILabel()
            sleepMsg.text = "就寝"
            sleepMsg.textColor = .white
            sleepMsg.font = .boldSystemFont(ofSize: 20)
            sleepView.addSubview(sleepMsg)

            sleepMsg.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalTo(sleepImg.snp.right)
                $0.right.equalToSuperview()
            }

            sleepView.snp.makeConstraints {
                $0.top.equalTo(time.snp.bottom).offset(15)
                $0.centerX.equalTo(KEYSCREEN_W/4-10)
                $0.top.bottom.equalTo(sleepImg)
            }
            
            bedtimeLabel = UILabel()
            bedtimeLabel.textColor = .white
            content.addSubview(bedtimeLabel)
            
            bedtimeLabel.snp.makeConstraints {
                $0.centerX.equalTo(sleepView).offset(5)
                $0.top.equalTo(sleepView.snp.bottom)
            }
            
            // 起床
            let wakeView = UIView()
            content.addSubview(wakeView)
            let wakeImg = UIImageView(image: #imageLiteral(resourceName: "sleep_asleep"))
            wakeView.addSubview(wakeImg)
            
            wakeImg.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview()
                $0.size.equalTo(wakeImg.image!.size)
            }
            
            let wakeMsg = UILabel()
            wakeMsg.text = "起床"
            wakeMsg.textColor = .white
            wakeMsg.font = .boldSystemFont(ofSize: 20)
            wakeView.addSubview(wakeMsg)
            
            wakeMsg.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalTo(wakeImg.snp.right)
                $0.right.equalToSuperview()
            }
            
            wakeView.snp.makeConstraints {
                $0.top.equalTo(time.snp.bottom).offset(15)
                $0.centerX.equalTo(KEYSCREEN_W/4*3)
                $0.top.bottom.equalTo(wakeImg)
            }
            
            wakeLabel = UILabel()
            wakeLabel.textColor = .white
            content.addSubview(wakeLabel)
            
            wakeLabel.snp.makeConstraints {
                $0.centerX.equalTo(wakeView).offset(5)
                $0.top.equalTo(wakeView.snp.bottom)
            }
            
            // 睡眠时长
            durationLabel = UILabel()
            durationLabel.textColor = .black
            content.addSubview(durationLabel)
            
            durationLabel.snp.makeConstraints {
                $0.center.equalTo(clock)
            }
            
            timeChanged(slider)
        } else {
            let bar = AAChartView()
            bar.isClearBackgroundColor = true
            chartView.addSubview(bar)
            
            bar.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            let dataFormatter = DateFormatter()
            dataFormatter.dateFormat = "yyyy-MM-dd"
            
            let chartModel = AAChartModel()
                .chartType(.column)
                .inverted(false)//是否翻转图形
                .title(dataFormatter.string(from: Date()))
                .titleFontColor(AAColor.white)
                .titleFontWeight(AAChartFontWeightType.bold)
                .titleFontSize(22)
                .legendEnabled(true)//是否启用图表的图例(图表底部的可点击的小圆点)
                .tooltipValueSuffix("小时")//浮动提示框单位后缀
                .categories([" ", " "])
                .axesTextColor(AAColor.white)
                .yAxisLabelsEnabled(false)
                .colorsTheme(["#fe117c", "#ffc069", "#06caf4", "#7dffc0"])//主题颜色数组
                .backgroundColor(AAColor.clear)
                .series([
                    AASeriesElement()
                        .name("浅睡")
                        .data([7.0, 6.9]),
                    AASeriesElement()
                        .name("深睡")
                        .data([9.3, 4.2]),
                    AASeriesElement()
                        .name("做梦")
                        .data([6.9, 5.6]),
                    AASeriesElement()
                        .name("醒来")
                        .data([7.9, 8.6])
                        ])

            bar.aa_drawChartWithChartModel(chartModel)
        }
        
        // 下面的数据
        let whiteView = UIView()
        whiteView.backgroundColor = UIColor.white
        content.addSubview(whiteView)
        
        let title = UILabel()
        title.text = "睡眠统计"
        title.isUserInteractionEnabled = true
        title.font = UIFont.boldSystemFont(ofSize: 24)
        whiteView.addSubview(title)
        
        title.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(20)
            $0.right.equalToSuperview()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToBarViewType))
        title.addGestureRecognizer(tap)
        
        if viewType == .clock {
            let btn = UIButton(type: .custom)
            btn.setImage(#imageLiteral(resourceName: "rightImg"), for: .normal)
            btn.addTarget(self, action: #selector(goToBarViewType), for: .touchUpInside)
            content.addSubview(btn)
            
            btn.snp.makeConstraints {
                $0.centerY.equalTo(title)
                $0.right.equalToSuperview().inset(10)
                $0.width.height.equalTo(title.snp.height)
            }
        }
        
        let sleepLight = UIImageView(image: #imageLiteral(resourceName: "sleep_light"))
        whiteView.addSubview(sleepLight)
        
        sleepLight.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(8)
            $0.left.equalTo(title.snp.left).offset(15)
        }
        
        let light = UILabel()
        light.text = "浅睡"
        light.font = UIFont.systemFont(ofSize: 18)
        whiteView.addSubview(light)
        
        light.snp.makeConstraints {
            $0.centerY.equalTo(sleepLight)
            $0.left.equalTo(sleepLight.snp.right).offset(8)
        }
        
        let lightLabel = UILabel()
        lightLabel.text = "3小时2分钟"
        lightLabel.font = UIFont.boldSystemFont(ofSize: 18)
        whiteView.addSubview(lightLabel)
        
        lightLabel.snp.makeConstraints {
            $0.centerY.equalTo(sleepLight)
            $0.right.equalToSuperview().inset(15)
        }
        
        let sleepDeep = UIImageView(image: #imageLiteral(resourceName: "sleep_deep"))
        whiteView.addSubview(sleepDeep)
        
        sleepDeep.snp.makeConstraints {
            $0.top.equalTo(sleepLight.snp.bottom).offset(8)
            $0.centerX.equalTo(sleepLight)
        }
        
        let deep = UILabel()
        deep.text = "深睡"
        deep.font = light.font
        whiteView.addSubview(deep)
        
        deep.snp.makeConstraints {
            $0.centerY.equalTo(sleepDeep)
            $0.left.equalTo(light)
        }
        
        let deepLabel = UILabel()
        deepLabel.text = "1小时45分钟"
        deepLabel.font = lightLabel.font
        whiteView.addSubview(deepLabel)
        
        deepLabel.snp.makeConstraints {
            $0.centerY.equalTo(sleepDeep)
            $0.right.equalToSuperview().inset(15)
        }
        
        let sleepDream = UIImageView(image: #imageLiteral(resourceName: "sleep_dream"))
        whiteView.addSubview(sleepDream)
        
        sleepDream.snp.makeConstraints {
            $0.top.equalTo(sleepDeep.snp.bottom).offset(8)
            $0.centerX.equalTo(sleepLight)
        }
        
        let dream = UILabel()
        dream.text = "做梦"
        dream.font = light.font
        whiteView.addSubview(dream)
        
        dream.snp.makeConstraints {
            $0.centerY.equalTo(sleepDream)
            $0.left.equalTo(light)
        }
        
        let dreamLabel = UILabel()
        dreamLabel.text = "1小时20分钟"
        dreamLabel.font = lightLabel.font
        whiteView.addSubview(dreamLabel)
        
        dreamLabel.snp.makeConstraints {
            $0.centerY.equalTo(sleepDream)
            $0.right.equalToSuperview().inset(15)
        }
        
        let sleepWeak = UIImageView(image: #imageLiteral(resourceName: "sleep_asleep"))
        whiteView.addSubview(sleepWeak)
        
        sleepWeak.snp.makeConstraints {
            $0.top.equalTo(sleepDream.snp.bottom).offset(8)
            $0.centerX.equalTo(sleepLight)
        }
        
        let weak = UILabel()
        weak.text = "醒来"
        weak.font = light.font
        whiteView.addSubview(weak)
        
        weak.snp.makeConstraints {
            $0.centerY.equalTo(sleepWeak)
            $0.left.equalTo(light)
        }
        
        let weakLabel = UILabel()
        weakLabel.text = "0小时30分钟"
        weakLabel.font = lightLabel.font
        whiteView.addSubview(weakLabel)
        
        weakLabel.snp.makeConstraints {
            $0.centerY.equalTo(sleepWeak)
            $0.right.equalToSuperview().inset(15)
        }
        
        whiteView.snp.makeConstraints {
            $0.top.equalTo(chartView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(sleepWeak.snp.bottom).offset(25)
        }
        
        content.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(KEYSCREEN_W)
            $0.bottom.equalTo(whiteView.snp.bottom)
        }
    }
    
    @objc func goToBarViewType() {
        if viewType == .bar {
            return
        }
        let vc = LTSleepViewController()
        vc.title = "睡眠"
        vc.viewType = .bar
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func timeChanged(_ action: RangeCircularSlider) {
        adjustValue(value: &slider.startPointValue)
        adjustValue(value: &slider.endPointValue)

        let bedtime = TimeInterval(slider.startPointValue)
        let bedtimeDate = Date(timeIntervalSinceReferenceDate: bedtime)
        let bedString = NSMutableAttributedString(string: dateFormatter.string(from: bedtimeDate))
        bedString.addAttributes([.font : UIFont.boldSystemFont(ofSize: 26)], range: NSRange(location: 0, length: bedString.length))
        bedString.addAttributes([.font : UIFont.systemFont(ofSize: 15)], range: NSRange(location: 0, length: 2))
        bedtimeLabel.attributedText = bedString

        let wake = TimeInterval(slider.endPointValue)
        let wakeDate = Date(timeIntervalSinceReferenceDate: wake)
        let wakeString = NSMutableAttributedString(string: dateFormatter.string(from: wakeDate))
        wakeString.addAttributes([.font : UIFont.boldSystemFont(ofSize: 26)], range: NSRange(location: 0, length: wakeString.length))
        wakeString.addAttributes([.font : UIFont.systemFont(ofSize: 15)], range: NSRange(location: 0, length: 2))
        wakeLabel.attributedText = wakeString
        
        let duration = wake - bedtime
        let durationDate = Date(timeIntervalSinceReferenceDate: duration)
        dateFormatter.dateFormat = "HH:mm"
        let durationStr = dateFormatter.string(from: durationDate)
        let times = durationStr.components(separatedBy: ":")
        var hous = ""
        var minute = ""
        times.enumerated().forEach { (index, str) in
            if let t = Int(str) {
                if index == 0 {
                    hous = "\(t)小时"
                } else if index == 1, t > 0 {
                    minute = "\(t)分"
                }
            }
        }
        let housStr = NSMutableAttributedString(string: hous)
        housStr.addAttributes([.font : UIFont.boldSystemFont(ofSize: 26)], range: NSRange(location: 0, length: housStr.length))
        housStr.addAttributes([.font : UIFont.systemFont(ofSize: 15)], range: NSRange(location: housStr.length-2, length: 2))
        if minute.count > 0 {
            let minuteStr = NSMutableAttributedString(string: minute)
            minuteStr.addAttributes([.font : UIFont.boldSystemFont(ofSize: 26)], range: NSRange(location: 0, length: minuteStr.length))
            minuteStr.addAttributes([.font : UIFont.systemFont(ofSize: 15)], range: NSRange(location: minuteStr.length-1, length: 1))
            
            housStr.append(minuteStr)
        }

        durationLabel.attributedText = housStr
        dateFormatter.dateFormat = "ahh:mm"
    }
    
    func adjustValue(value: inout CGFloat) {
        let minutes = value / 60
        let adjustedMinutes =  ceil(minutes / 5.0) * 5
        value = adjustedMinutes * 60
    }
    
    @objc func shareAction() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = LTTheme.sleepBG
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

extension LTSleepViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            bgView.frame.origin.y = -scrollView.contentOffset.y
        } else {
            bgView.frame.origin.y = 0
            bgView.frame.size.height = KEYSCREEN_W-scrollView.contentOffset.y
        }
    }
}

extension LTSleepViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchView = touch.view, touchView is RangeCircularSlider {
            return false
        }
        return true
    }
}
