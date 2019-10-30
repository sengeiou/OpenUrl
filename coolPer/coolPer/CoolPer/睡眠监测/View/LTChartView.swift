//
//  LTChartView.swift
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

class LTChartView: UIView {
    var scorll: UIScrollView?
    var viewType: LTSleepViewController.ViewType!

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if viewType == .clock {
            for sub in subviews {
                let subPoint = convert(point, to: sub)
                if let hitView = sub.hitTest(subPoint, with: event) {
                    if hitView is RangeCircularSlider {
                        let subView = hitView as! RangeCircularSlider
                        let stutas = subView.thumb(for: subPoint)
                        if stutas == .none {
                            return self
                        }
                        scorll?.isScrollEnabled = false
                        DispatchQueue.main.asyncAfter(wallDeadline: .now()+0.25) {
                            self.scorll?.isScrollEnabled = true
                        }
                        return hitView
                    }
                }
            }
            return self
        } else {
            return super.hitTest(point, with: event)
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
