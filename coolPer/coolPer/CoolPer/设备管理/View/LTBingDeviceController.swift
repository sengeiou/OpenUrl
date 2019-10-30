//
//  LTBingDeviceController.swift
//  coolPer
//
//  Created by LonTe on 2019/7/23.
//  Copyright © 2019 LangTe. All rights reserved.
//

import UIKit
import AVFoundation

class LTBingDeviceController: LTViewController {
    var isLogin = false
    var videoDataOutput: AVCaptureVideoDataOutput?
    var session: AVCaptureSession?
    var videoPreview: AVCaptureVideoPreviewLayer?
    
    var width: CGFloat = 0
    var height: CGFloat = 0
    var x: CGFloat = 0
    var y: CGFloat = 0
    let imageView = UIImageView(image: #imageLiteral(resourceName: "scan_line"))
    var timer: CADisplayLink?
    var deviceNum = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "绑定设备"
        // Do any additional setup after loading the view.
        width = view.bounds.width-100
        height = width
        x = (view.bounds.width-width)/2
        y = (view.bounds.height-height)/2
        
        configScan()
        coverView()
        scanLine()
        
        let msg = UILabel()
        msg.text = "请扫描设备与包装盒上的二维码"
        msg.textColor = UIColor.white.withAlphaComponent(0.7)
        msg.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(msg)
        msg.sizeToFit()
        msg.center = view.center
        msg.center.y = y-msg.frame.height-5
        
        let noScan = UIButton(type: .custom)
        noScan.setTitle("识别不成功，手动输入试试？", for: .normal)
        noScan.setTitleColor(msg.textColor, for: .normal)
        noScan.titleLabel?.font = msg.font
        noScan.backgroundColor = UIColor.clear
        view.addSubview(noScan)
        noScan.sizeToFit()
        noScan.center = view.center
        noScan.center.y = y+height+noScan.frame.height+5
        
        noScan.addTarget(self, action: #selector(inpuDeviceInfo), for: .touchUpInside)
    }
    
    @objc func inpuDeviceInfo() {
        stopScan()
        let alert = UIAlertController(title: "", message: "在此手动输入设备序列号", preferredStyle: .alert)
        if #available(iOS 13.0, *) {
            alert.overrideUserInterfaceStyle = .light
        }
        alert.addTextField { (textField) in
            textField.placeholder = "请输入序列号"
            textField.keyboardType = .alphabet
            textField.addTarget(self, action: #selector(self.inpuDeviceNum(_:)), for: .editingChanged)
        }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
            self.deviceNum = ""
            self.startScan()
        }))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            self.jumpBing(deviceNo: self.deviceNum)
        }))
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
    @objc func inpuDeviceNum(_ textField: UITextField) {
        textField.text = textField.text?.uppercased()
        deviceNum = textField.text ?? ""
    }
    
    func jumpBing(deviceNo: String) {
        if deviceNo.count == 0 {
            startScan()
            return
        }
        deviceNum = ""
        navigationController?.pushViewController(LTDeviceInfoController(), animated: true)
    }
    
    private func configScan() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        guard let deviceInput = try? AVCaptureDeviceInput(device: device) else { return }
        let metadataOutput = AVCaptureMetadataOutput()
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput?.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        session = AVCaptureSession()
        session?.sessionPreset = .hd1920x1080
        session?.addOutput(metadataOutput)
        session?.addOutput(videoDataOutput!)
        session?.addInput(deviceInput)
        metadataOutput.metadataObjectTypes = [.qr]
        metadataOutput.rectOfInterest = CGRect(x: y/view.bounds.height, y: x/view.bounds.width, width: height/view.bounds.height, height: width/view.bounds.width)
        videoPreview = AVCaptureVideoPreviewLayer(session: session!)
        videoPreview?.videoGravity = .resizeAspectFill
        videoPreview?.frame = view.bounds
        view.layer.insertSublayer(videoPreview!, at: 0)
    }
    
    private func coverView() {
        let cover = CAShapeLayer()
        cover.frame = view.bounds
        cover.strokeColor = UIColor.clear.cgColor
        cover.lineJoin = .miter
        cover.fillColor = UIColor.black.withAlphaComponent(0.7).cgColor
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x, y: 0))
        path.addLine(to: CGPoint(x: x, y: y+height))
        path.addLine(to: CGPoint(x: x+width, y: y+height))
        path.addLine(to: CGPoint(x: x+width, y: y))
        path.addLine(to: CGPoint(x: x, y: y))
        path.addLine(to: CGPoint(x: x, y: 0))
        path.addLine(to: CGPoint(x: view.bounds.width, y: 0))
        path.addLine(to: CGPoint(x: view.bounds.width, y: view.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: view.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()

        cover.path = path.cgPath
        view.layer.addSublayer(cover)
        
        let rect = CAShapeLayer()
        rect.frame = view.bounds
        rect.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
        rect.lineJoin = .miter
        rect.fillColor = UIColor.clear.cgColor
        rect.lineWidth = 0.5
        
        let rectPath = UIBezierPath()
        rectPath.move(to: CGPoint(x: x, y: y))
        rectPath.addLine(to: CGPoint(x: x+width, y: y))
        rectPath.addLine(to: CGPoint(x: x+width, y: y+height))
        rectPath.addLine(to: CGPoint(x: x, y: y+height))
        rectPath.close()
        
        rect.path = rectPath.cgPath
        view.layer.addSublayer(rect)
        
        let corner = CAShapeLayer()
        corner.frame = view.bounds
        corner.strokeColor = LTTheme.navBG.cgColor
        corner.lineJoin = .miter
        corner.fillColor = UIColor.clear.cgColor
        corner.lineWidth = 3
        
        let cornerLenth: CGFloat = 20
        let cornerPath = UIBezierPath()
        cornerPath.move(to: CGPoint(x: x+1+cornerLenth, y: y+1))
        cornerPath.addLine(to: CGPoint(x: x+1, y: y+1))
        cornerPath.addLine(to: CGPoint(x: x+1, y: y+1+cornerLenth))
        
        cornerPath.move(to: CGPoint(x: x+width-1-cornerLenth, y: y+1))
        cornerPath.addLine(to: CGPoint(x: x+width-1, y: y+1))
        cornerPath.addLine(to: CGPoint(x: x+width-1, y: y+1+cornerLenth))
        
        cornerPath.move(to: CGPoint(x: x+width-1-cornerLenth, y: y+height-1))
        cornerPath.addLine(to: CGPoint(x: x+width-1, y: y+height-1))
        cornerPath.addLine(to: CGPoint(x: x+width-1, y: y+height-1-cornerLenth))

        cornerPath.move(to: CGPoint(x: x+1+cornerLenth, y: y+height-1))
        cornerPath.addLine(to: CGPoint(x: x+1, y: y+height-1))
        cornerPath.addLine(to: CGPoint(x: x+1, y: y+height-1-cornerLenth))

        corner.path = cornerPath.cgPath
        view.layer.addSublayer(corner)
    }
    
    private func scanLine() {
        guard let image = imageView.image else { return }
        let imageViewHeight = width*image.size.height/image.size.width
        imageView.frame = CGRect(x: x, y: y, width: width, height: imageViewHeight)
        imageView.isHidden = true
        view.addSubview(imageView)
    }
    
    private func startScan() {
        if let sess = session, !sess.isRunning {
            session?.startRunning()
        }
        imageView.isHidden = false
        imageView.center.y = y+3
        timer = CADisplayLink(target: self, selector: #selector(updateLine))
        timer?.add(to: RunLoop.current, forMode: .default)
    }
    
    @objc private func updateLine() {
        imageView.center.y += 2

        if imageView.center.y >= y+height {
            imageView.center.y = y+3
        }
    }
    
    private func stopScan() {
        if let sess = session, sess.isRunning {
            session?.stopRunning()
        }
        imageView.isHidden = true
        timer?.invalidate()
    }
    
    override func navigationShouldPopOnBackButton() -> Bool {
        if isLogin {
            stopScan()
            let alert = UIAlertController(title: "", message: "还未绑定设备，确定要退出？", preferredStyle: .alert)
            if #available(iOS 13.0, *) {
                alert.overrideUserInterfaceStyle = .light
            } 
            alert.addAction(UIAlertAction(title: "否", style: .cancel, handler: { (_) in
                self.startScan()
            }))
            alert.addAction(UIAlertAction(title: "是", style: .default, handler: { (_) in
                self.navigationController?.dismiss(animated: true, completion: nil)
            }))
            navigationController?.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = nil
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isLogin {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        startScan()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barTintColor = LTTheme.navBG
        navigationController?.navigationBar.isTranslucent = false
        
        stopScan()
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

extension LTBingDeviceController: AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if let string = metadata.stringValue, string.count > 0 {
                session?.stopRunning()
                jumpBing(deviceNo: string)
                print(string)
            }
        }
    }
}
