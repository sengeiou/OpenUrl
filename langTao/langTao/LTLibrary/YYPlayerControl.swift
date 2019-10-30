//
//  YYPlayerControl.swift
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
//  Created by LonTe on 2019/9/12.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

protocol YYPlayerControlDelegate: NSObjectProtocol {
    func playerControlTimeStartSlider(playerControl: YYPlayerControl, value: Float)
    func playerControlTimeValueDidChanged(playerControl: YYPlayerControl, value: Float)
    func playerControlTimeEndSlider(playerControl: YYPlayerControl, value: Float)
    func playerControlPlayOrPauseClick(playerControl: YYPlayerControl, status: YYPlayerControl.ControlStatus)
}

class YYPlayerControl: UIControl {
    enum ControlStatus {
        case playing
        case pause
    }
    weak var delegate: YYPlayerControlDelegate?
    var slidering = false
    var controlStatus: ControlStatus = .playing {
        didSet {
            changBtnStatus()
        }
    }
    
    lazy var buffSlider: UISlider = {
        let buffSlider = UISlider()
        buffSlider.contentVerticalAlignment = .bottom
        buffSlider.isUserInteractionEnabled = false
        buffSlider.maximumValue = 1
        buffSlider.minimumValue = 0
        buffSlider.minimumTrackTintColor = UIColor.gray
        buffSlider.maximumTrackTintColor = UIColor.lightGray
        buffSlider.setThumbImage(UIImage(), for: .normal)
        addSubview(buffSlider)
        
        return buffSlider
    }()
    lazy var timeSlider: UISlider = {
        let timeSlider = UISlider()
        timeSlider.addTarget(self, action: #selector(valueChange), for: .valueChanged)
        timeSlider.addTarget(self, action: #selector(touchDown), for: .touchDown)
        timeSlider.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        timeSlider.contentVerticalAlignment = .bottom
        timeSlider.maximumValue = 1
        timeSlider.minimumValue = 0
        timeSlider.minimumTrackTintColor = UIColor.green
        timeSlider.maximumTrackTintColor = UIColor.clear
        timeSlider.setThumbImage(#imageLiteral(resourceName: "progress"), for: .normal)
        addSubview(timeSlider)
        
        return timeSlider
    }()
    lazy var currentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "--:--"
        addSubview(label)
        
        return label
    }()
    lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "--:--"
        addSubview(label)

        return label
    }()
    private lazy var playOrPause: UIButton = {
        let pOp = UIButton(type: .custom)
        pOp.addTarget(self, action: #selector(playOrPauseAction), for: .touchUpInside)
        addSubview(pOp)
        
        return pOp
    }()
    
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.clear
        buffSlider.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(70)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(40)
        }
        
        timeSlider.snp.makeConstraints {
            $0.edges.equalTo(buffSlider)
        }
        
        currentLabel.snp.makeConstraints {
            $0.centerY.equalTo(timeSlider)
            $0.right.equalTo(timeSlider.snp.left).offset(-10)
        }
        
        durationLabel.snp.makeConstraints {
            $0.centerY.equalTo(timeSlider)
            $0.left.equalTo(timeSlider.snp.right).offset(10)
        }
        
        playOrPause.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(60)
        }
    }
    
    private func changBtnStatus() {
        switch controlStatus {
        case .playing:
            playOrPause.setImage(#imageLiteral(resourceName: "suspend"), for: .normal)
        case .pause:
            playOrPause.setImage(#imageLiteral(resourceName: "playing"), for: .normal)
        }
    }
    
    @objc private func playOrPauseAction() {
        delegate?.playerControlPlayOrPauseClick(playerControl: self, status: controlStatus)
    }
    
    @objc private func valueChange() {
        delegate?.playerControlTimeValueDidChanged(playerControl: self, value: timeSlider.value)
    }
    
    @objc private func touchDown() {
        slidering = true
        delegate?.playerControlTimeStartSlider(playerControl: self, value: timeSlider.value)
    }
    
    @objc private func touchUpInside() {
        timeSlider.isUserInteractionEnabled = false
        delegate?.playerControlTimeEndSlider(playerControl: self, value: timeSlider.value)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension UIScrollView {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if isScrollEnabled {
            if view is UISlider {
                isScrollEnabled = false
                DispatchQueue.main.asyncAfter(wallDeadline: .now()+0.25) {
                    self.isScrollEnabled = true
                }
            }
        }
        return view
    }
}
