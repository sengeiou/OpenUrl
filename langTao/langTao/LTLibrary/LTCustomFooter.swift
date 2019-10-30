//
//  LTCustomFooter.swift
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

class LTCustomFooter: UIView, CRRefreshProtocol {
    
    var view: UIView { return self }
    var duration: TimeInterval = 0.3
    var insets: UIEdgeInsets   = .zero
    var trigger: CGFloat       = 50.0
    var execute: CGFloat       = 50.0
    var endDelay: CGFloat      = 0
    var hold: CGFloat          = 50
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.init(white: 160.0 / 255.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView.init(style: .gray)
        indicatorView.isHidden = true
        return indicatorView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = "CRRefreshFooterIdleText".localString
        addSubview(titleLabel)
        addSubview(indicatorView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshBegin(view: CRRefreshComponent) {
        indicatorView.startAnimating()
        titleLabel.text = "CRRefreshFooterRefreshingText".localString
        indicatorView.isHidden = false
    }
    
    public func refreshWillEnd(view: CRRefreshComponent) {
        
    }
    
    func refreshEnd(view: CRRefreshComponent, finish: Bool) {
        indicatorView.stopAnimating()
        titleLabel.text = "CRRefreshFooterIdleText".localString
        indicatorView.isHidden = true
    }
    
    func refresh(view: CRRefreshComponent, progressDidChange progress: CGFloat) {
        
    }
    
    func refresh(view: CRRefreshComponent, stateDidChange state: CRRefreshState) {
        switch state {
        case .refreshing :
            titleLabel.text = "CRRefreshFooterRefreshingText".localString
            break
        case .noMoreData:
            titleLabel.text = "CRRefreshFooterNoMoreText".localString
            break
        case .pulling:
            titleLabel.text = "CRRefreshFooterIdleText".localString
            break
        default:
            break
        }
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let s = self.bounds.size
        let w = s.width
        let h = s.height
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint.init(x: w / 2.0, y: h / 2.0 - 5.0 + insets.top)
        indicatorView.center = CGPoint.init(x: titleLabel.frame.origin.x - 18.0, y: titleLabel.center.y)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
