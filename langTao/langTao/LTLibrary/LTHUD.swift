//
//  LTHUD.swift
//  YYProject
//
//  Created by haozhiyu on 2018/11/18.
//  Copyright © 2018年 haozhiyu. All rights reserved.
//

import UIKit
import MBProgressHUD

class LTHUD {
    static let shared = LTHUD()
    private var count = 0
    private init() { }
    private func show() {
        count += 1
    }
    
    private func hide() {
        count -= 1
    }
    
    enum AlertType {
        case success
        case info
        case error
        case warning
    }
    
    class func reset() {
        LTHUD.shared.count = 1
        LTHUD.hide()
    }
    
    class func show(inView view: UIView? = .none) {
        LTHUD.shared.show()
        var onView: UIView!
        if let inview = view {
            onView = inview
        } else {
            if let window = UIApplication.shared.delegate?.window {
                onView = window!
            }
        }
        if cheakHUDIsHas(onView) {
            return
        }
        let hud = MBProgressHUD.showAdded(to: onView, animated: true)
        hud.tag = 68
    }
    
    class func hide(forView view: UIView? = .none) {
        LTHUD.shared.hide()
        if LTHUD.shared.count != 0 {
            return
        }
        var forView: UIView!
        if let inView = view {
            forView = inView
        } else {
            if let window = UIApplication.shared.delegate?.window {
                forView = window!
            }
        }
        for hud in forView.subviews {
            if hud is MBProgressHUD, hud.tag == 68 {
                (hud as! MBProgressHUD).hide(animated: true)
                return
            }
        }
    }
    
    private class func cheakHUDIsHas(_ view: UIView) -> Bool {
        for view in view.subviews {
            if view is MBProgressHUD, view.tag == 68 {
                return true
            }
        }
        return false
    }
    
    class func show(type: AlertType? = .none, text: String) {
        if let window = UIApplication.shared.delegate?.window {
            let hud = MBProgressHUD.showAdded(to: window!, animated: true)
            hud.mode = .customView
            if let t = type {
                var image: UIImage
                switch t {
                case .success:
                    image = #imageLiteral(resourceName: "Alert_success")
                case .info:
                    image = #imageLiteral(resourceName: "Alert_info")
                case .error:
                    image = #imageLiteral(resourceName: "Alert_error")
                case .warning:
                    image = #imageLiteral(resourceName: "Alert_warning")
                }
                hud.customView = UIImageView(image:image)
            }
            hud.detailsLabel.text = text
            hud.hide(animated: true, afterDelay: 1.2)
        }
    }
}
