//
//  YYPlayerView.swift
//  uploadVideo
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
//  Created by LonTe on 2019/9/9.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit
import AVKit

class YYPlayerView: UIView {
    enum ControlStatus {
        case playing
        case paused
        case none
    }
    enum ViewStatus {
        case cover
        case real
    }
    enum CoverPlayType {
        case once
        case cycle
    }
    var coverPlayType: CoverPlayType = .once
    private var _status: ControlStatus = .none
    var status: ControlStatus {
        return _status
    }
    var viewStatus: ViewStatus = .cover {
        didSet {
            changedViewStatus()
        }
    }
    
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var loading = false
    private var duration: Double = 0
    private lazy var loadingImage: LoadingView = {
        let loading = LoadingView()
        addSubview(loading)
        
        loading.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        return loading
    }()
    private lazy var buffSlider: UISlider = {
        let buffSlider = UISlider()
        buffSlider.contentVerticalAlignment = .bottom
        buffSlider.isUserInteractionEnabled = false
        buffSlider.maximumValue = 1
        buffSlider.minimumValue = 0
        buffSlider.minimumTrackTintColor = UIColor.gray
        buffSlider.maximumTrackTintColor = UIColor.lightGray
        buffSlider.setThumbImage(UIImage(), for: .normal)
        addSubview(buffSlider)
        
        buffSlider.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(4)
        }
        return buffSlider
    }()
    private lazy var timeSlider: UISlider = {
        let timeSlider = UISlider()
        timeSlider.contentVerticalAlignment = .bottom
        timeSlider.isUserInteractionEnabled = false
        timeSlider.maximumValue = 1
        timeSlider.minimumValue = 0
        timeSlider.minimumTrackTintColor = UIColor.green
        timeSlider.maximumTrackTintColor = UIColor.clear
        timeSlider.setThumbImage(UIImage(), for: .normal)
        addSubview(timeSlider)
        
        timeSlider.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(4)
        }
        return timeSlider
    }()
    private lazy var surplusLabel: UILabel = {
        let surplusLabel = UILabel()
        surplusLabel.textColor = UIColor.white
        surplusLabel.font = UIFont.systemFont(ofSize: 13)
        surplusLabel.text = ""
        addSubview(surplusLabel)
        
        surplusLabel.snp.makeConstraints {
            $0.right.bottom.equalToSuperview().inset(10)
        }
        return surplusLabel
    }()
    lazy var mutedBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(mutedBtnAction), for: .touchUpInside)
        addSubview(btn)
        
        btn.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.centerX.equalTo(surplusLabel)
            $0.bottom.equalTo(surplusLabel.snp.top)
        }
        return btn
    }()
    lazy var controll: YYPlayerControl = {
        let ctrl = YYPlayerControl()
        ctrl.addTarget(self, action: #selector(showOrHiddenContorll), for: .touchUpInside)
        ctrl.delegate = self
        ctrl.alpha = 0
        addSubview(ctrl)
        
        ctrl.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return ctrl
    }()
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    private var showReal: (()->())?
    private var currentTime: ((Double)->())?
    var timer: DispatchSourceTimer?
    
    init() {
        super.init(frame: .zero)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tap)
        audioCategory()
    }
    
    private func audioCategory() {
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func changedViewStatus() {
        switch viewStatus {
        case .cover:
            player?.isMuted = true
            buffSlider.isHidden = false
            timeSlider.isHidden = false
            surplusLabel.isHidden = false
            mutedBtn.isHidden = false
        case .real:
            player?.isMuted = false
            buffSlider.isHidden = true
            timeSlider.isHidden = true
            surplusLabel.isHidden = true
            mutedBtn.isHidden = true
        }
    }
    
    @objc private func mutedBtnAction() {
        if let p = player {
            if p.isMuted {
                player?.isMuted = false
            } else {
                player?.isMuted = true
            }
            let image = p.isMuted ? #imageLiteral(resourceName: "静音") : #imageLiteral(resourceName: "声音")
            self.mutedBtn.setImage(image, for: .normal)
        }
    }
    
    @objc private func showOrHiddenContorll() {
        if status == .none {
            return
        }
        if controll.alpha == 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.controll.alpha = 1
            }) { (_) in
                self.delayHiddenContorll()
            }
        } else {
            self.timer?.cancel()
            UIView.animate(withDuration: 0.25) {
                self.controll.alpha = 0
            }
        }
    }
    
    private func delayHiddenContorll() {
        timer = DispatchSource.makeTimerSource(flags: [], queue: .global())
        timer?.schedule(wallDeadline: .now()+3, repeating: 3, leeway: .milliseconds(1))
        timer?.setEventHandler(handler: {
            DispatchQueue.main.async {
                self.hiddenContorll()
            }
        })
        timer?.resume()
    }
    
    private func hiddenContorll() {
        timer?.cancel()
        UIView.animate(withDuration: 0.25) {
            self.controll.alpha = 0
        }
    }
    
    private func showContorll() {
        timer?.cancel()
        UIView.animate(withDuration: 0.25) {
            self.controll.alpha = 1
        }
    }
    
    @objc private func tapAction() {
        switch viewStatus {
        case .cover:
            showReal?()
        case .real:
            showOrHiddenContorll()
        }
    }
    /// 封面点击回调
    ///
    /// - Parameter toReal: 点击回调方法
    func clickCover(_ toReal: @escaping ()->()) {
        showReal = toReal
    }
    /// 继续播放
    func play() {
        if let iPlayer = player {
            _status = .playing
            iPlayer.play()
        }
    }
    /// 暂停
    func pause() {
        if let iPlayer = player {
            _status = .paused
            iPlayer.pause()
        }
    }
    /// 跳转播放
    ///
    /// - Parameter seconds: 跳转秒数
    func seek(to seconds: Double, completionHandler: (()->())? = nil) {
        player?.seek(to: CMTime(seconds: seconds, preferredTimescale: 600)) { _ in
            completionHandler?()
        }
    }
    /// 停止播放
    func stop() {
        player?.isMuted = true
        removeObserver()
        removeFromSuperview()
    }
    /// 静音
    ///
    /// - Parameter isMuted: 是否静音
    func muted(isMuted: Bool) {
        player?.isMuted = isMuted
    }
    /// 播放时的回调
    ///
    /// - Parameter time: 回调函数
    func periodicTime(time: @escaping (Double)->()) {
        currentTime = time
    }
    /// 播放
    ///
    /// - Parameter url: 视频utl
    func play(url: URL) {
        removeObserver()
        showLoadingView()
        
        playerItem = AVPlayerItem(url: url)
        playerItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        playerItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        player = AVPlayer(playerItem: playerItem)
        if let playerLayer = layer as? AVPlayerLayer {
            playerLayer.backgroundColor = UIColor.black.cgColor
            playerLayer.player = player
        }
        player?.addObserver(self, forKeyPath: "timeControlStatus", options: .new, context: nil)
        
        player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 600), queue: DispatchQueue.main) { [weak player, weak self] (time) in
            guard let `player` = player else { return }
            guard let `self` = self else { return }
            guard let item = player.currentItem else { return }
            let duration = CMTimeGetSeconds(item.duration)
            let current = CMTimeGetSeconds(time)
            guard !duration.isNaN, !current.isNaN else { return }
            let value = current/duration
            self.duration = duration
            self.timeSlider.value = Float(value)
            self.surplusLabel.text = (duration-current).stringFormat
            let image = player.isMuted ? #imageLiteral(resourceName: "静音") : #imageLiteral(resourceName: "声音")
            self.mutedBtn.setImage(image, for: .normal)
            if !self.controll.slidering {
                self.controll.timeSlider.value = Float(value)
                self.controll.currentLabel.text = current.stringFormat
            }
            self.controll.durationLabel.text = duration.stringFormat
            self.currentTime?(current)
        }
        
        buffSlider.value = 0
        timeSlider.value = 0
        controll.buffSlider.value = 0
        controll.timeSlider.value = 0
        surplusLabel.text = ""
        controll.currentLabel.text = ""
        controll.durationLabel.text = ""
        changedViewStatus()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            guard let item = playerItem else { return }
            switch item.status {
            case .readyToPlay:
                play()
            default:
                LTHUD.show(text: "Video Address Error".localString)
            }
        } else if keyPath == "loadedTimeRanges" {
            guard let item = playerItem else { return }
            guard let iPlayer = player else { return }
            if let time = item.loadedTimeRanges.first as? CMTimeRange {
                let start = CMTimeGetSeconds(time.start)
                let duration = CMTimeGetSeconds(time.duration)
                let total = start+duration
                let value = total/CMTimeGetSeconds(item.duration)
                buffSlider.value = Float(value)
                controll.buffSlider.value = Float(value)
                switch iPlayer.timeControlStatus {
                case .playing, .paused:
                    hiddenLoadingView()
                case .waitingToPlayAtSpecifiedRate:
                    showLoadingView()
                default:
                    break
                }
            }
        } else if keyPath == "playbackLikelyToKeepUp" {
            if status == .playing {
                play()
            }
        } else if keyPath == "timeControlStatus" {
            guard let iPlayer = player else { return }
            switch iPlayer.timeControlStatus {
            case .playing, .waitingToPlayAtSpecifiedRate:
                if status == .paused {
                    pause()
                }
                controll.controlStatus = .playing
            case .paused:
                if status == .playing {
                    play()
                }
                controll.controlStatus = .pause
            default:
                break
            }
        }
    }
    
    private func showLoadingView() {
        if !loading {
            loading = true
            loadingImage.isHidden = false
        }
    }
    
    private func hiddenLoadingView() {
        if loading {
            loading = false
            loadingImage.isHidden = true
        }
    }

    class func transformMovie(inpuUrl: URL, outUrl: URL) {
        let urlAsset = AVURLAsset(url: inpuUrl)
        let session = AVAssetExportSession.exportPresets(compatibleWith: urlAsset)
        if session.contains(AVAssetExportPresetMediumQuality) {
            let export = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality)!
            if FileManager.default.fileExists(atPath: outUrl.path) {
                print("存在")
                do {
                    try FileManager.default.removeItem(at: outUrl)
                } catch {
                    print(error)
                }
            }
            export.outputURL = outUrl
            export.outputFileType = .mp4
            export.shouldOptimizeForNetworkUse = true
            export.exportAsynchronously {
                switch export.status {
                case .completed:
                    print("完成")
                default:
                    print("格式转换出错")
                }
            }
        }
    }
    
    private func removeObserver() {
        _status = .none
        playerItem?.removeObserver(self, forKeyPath: "status", context: nil)
        playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges", context: nil)
        playerItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp", context: nil)
        player?.removeObserver(self, forKeyPath: "timeControlStatus", context: nil)
        playerItem = nil
        player = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func playToEndTime() {
        _status = .none
        currentTime?(0)
        if viewStatus == .cover {
            switch coverPlayType {
            case .once:
                removeObserver()
                removeFromSuperview()
            case .cycle:
                play()
                seek(to: 0)
            }
        } else {
            showContorll()
        }
    }
    
    deinit {
        #if DEBUG
        print("\(self.classForCoder) 🐳 deinit")
        #endif
        removeObserver()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension YYPlayerView: YYPlayerControlDelegate {
    func playerControlTimeStartSlider(playerControl: YYPlayerControl, value: Float) {
        timer?.cancel()
    }
    
    func playerControlTimeValueDidChanged(playerControl: YYPlayerControl, value: Float) {
        let s = duration*Double(value)
        controll.currentLabel.text = s.stringFormat
    }
    
    func playerControlTimeEndSlider(playerControl: YYPlayerControl, value: Float) {
        delayHiddenContorll()
        let s = duration*Double(value)
        seek(to: s) { [weak self] in
            guard let `self` = self else { return }
            self.controll.slidering = false
            self.controll.timeSlider.isUserInteractionEnabled = true
        }
    }
    
    func playerControlPlayOrPauseClick(playerControl: YYPlayerControl, status: YYPlayerControl.ControlStatus) {
        switch status {
        case .playing:
            pause()
        case .pause:
            if self.status == .none {
                play()
                seek(to: 0)
            } else {
                play()
            }
        }
    }
}

extension Float64 {
    var stringFormat: String {
        guard !isNaN else {
            return ""
        }
        let m = Int(self/60)
        let s = Int(self)%60
        return String(format: "%02d:%02d", m, s)
    }
}

class LoadingView: UIView {
    private var oval: CAShapeLayer!
    private var isHasOval = false
    private var timer = DispatchSource.makeTimerSource(flags: [], queue: .global())
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isHasOval {
            isHasOval = true
            let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
            
            oval = CAShapeLayer()
            oval.frame = bounds
            oval.path = path.cgPath
            oval.strokeColor = UIColor.white.cgColor
            oval.fillColor = UIColor.clear.cgColor
            oval.lineCap = .round
            oval.lineWidth = 3
            oval.transform = CATransform3DMakeRotation(-.pi/2, 0, 0, 1)
            oval.strokeStart = 0
            oval.strokeEnd = 0
            
            layer.addSublayer(oval)
            
            var show = true
            timer.schedule(wallDeadline: .now(), repeating: 0.6, leeway: .milliseconds(1))
            timer.setEventHandler { [weak self] in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    if show {
                        self.oval.strokeStart = 0.02
                        self.oval.strokeEnd = 0.98
                        
                        let animation = CABasicAnimation(keyPath: "strokeEnd")
                        animation.duration = 0.6
                        animation.fromValue = 0.02
                        animation.toValue = 0.98
                        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                        self.oval.add(animation, forKey: "strokeEnd")
                    } else {
                        self.oval.strokeStart = 0.98
                        self.oval.strokeEnd = 0.98
                        
                        let animation = CABasicAnimation(keyPath: "strokeStart")
                        animation.duration = 0.6
                        animation.fromValue = 0.02
                        animation.toValue = 0.98
                        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                        self.oval.add(animation, forKey: "strokeStart")
                    }
                    show = !show
                }
            }
            timer.resume()
        }
    }
}
