////
////  ScanCodeViewController.swift
////  YMQRCodeDemo
////
////  Created by YDWY on 2017/5/6.
////  Copyright © 2017年 YDWY. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//
//private let scanAnimationDuration = 3.0//扫描时长
//
//
//class ScanCodeViewController: UIViewController {
//
//    //MARK: -
//    //MARK: Global Variables
//    
//    var scanPane: UIImageView!///扫描框
//    var activityIndicatorView: UIActivityIndicatorView!
//    
//    var lightOn = false///开光灯
//    
//    
//    //MARK: -
//    //MARK: Lazy Components
//    
//    lazy var scanLine : UIImageView =
//        {
//            
//            let scanLine = UIImageView()
//            scanLine.frame = CGRect(x: 0, y: 0, width: self.scanPane.bounds.width, height: 3)
//            scanLine.image = UIImage(named: "QRCode_ScanLine")
//            
//            return scanLine
//            
//    }()
//    
//    var scanSession :  AVCaptureSession?
//    
//    
//    //MARK: -
//    //MARK: Public Methods
//    
//    
//    //MARK: -
//    //MARK: Data Initialize
//    
//    
//    //MARK: -
//    //MARK: Life Cycle
//    
//    override func viewDidLoad()
//    {
//        
//        super.viewDidLoad()
//        
//        setupUI()
//        
//
//        view.layoutIfNeeded()
//        scanPane.addSubview(scanLine)
//        
//        setupScanSession()
//        
//    }
//    
//    
//    private func setupUI(){
//        scanPane = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
//        scanPane.image = UIImage(named: "QRCode_ScanBox")
//        scanPane.center = view.center
//        view.addSubview(scanPane)
//        
//        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//        activityIndicatorView.center = view.center
//        view.addSubview(activityIndicatorView)
//
//        
//        
//        
//    }
//    
//    
//    override func viewWillAppear(_ animated: Bool)
//    {
//        super.viewWillAppear(animated)
//        
//        startScan()
//        
//    }
//    
//    
//    //MARK: -
//    //MARK: Interface Components
//    
//    func setupScanSession()
//    {
//        
//        do
//        {
//            //设置捕捉设备
//            let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
//            //设置设备输入输出
//            let input = try AVCaptureDeviceInput(device: device)
//            
//            let output = AVCaptureMetadataOutput()
//            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            
//            //设置会话
//            let  scanSession = AVCaptureSession()
//            scanSession.canSetSessionPreset(AVCaptureSessionPresetHigh)
//            
//            if scanSession.canAddInput(input)
//            {
//                scanSession.addInput(input)
//            }
//            
//            if scanSession.canAddOutput(output)
//            {
//                scanSession.addOutput(output)
//            }
//            
//            //设置扫描类型(二维码和条形码)
//            output.metadataObjectTypes = [
//                AVMetadataObjectTypeQRCode,
//                AVMetadataObjectTypeCode39Code,
//                AVMetadataObjectTypeCode128Code,
//                AVMetadataObjectTypeCode39Mod43Code,
//                AVMetadataObjectTypeEAN13Code,
//                AVMetadataObjectTypeEAN8Code,
//                AVMetadataObjectTypeCode93Code]
//            
//            //预览图层
//            let scanPreviewLayer = AVCaptureVideoPreviewLayer(session:scanSession)
//            scanPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
//            scanPreviewLayer!.frame = view.layer.bounds
//            
//            view.layer.insertSublayer(scanPreviewLayer!, at: 0)
//            
//            //设置扫描区域
//            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil, using: { (noti) in
//                output.rectOfInterest = (scanPreviewLayer?.metadataOutputRectOfInterest(for: self.scanPane.frame))!
//            })
//            
//            
//            
//            //保存会话
//            self.scanSession = scanSession
//            
//        }
//        catch
//        {
//            //摄像头不可用
//            
//            Tool.confirm(title: "温馨提示", message: "摄像头不可用", controller: self)
//            
//            return
//        }
//        
//    }
//    
//    //MARK: -
//    //MARK: Target Action
//    
//    //闪光灯
//    @IBAction func light(_ sender: UIButton)
//    {
//        
//        lightOn = !lightOn
//        sender.isSelected = lightOn
//        turnTorchOn()
//        
//    }
//    
//    //相册
//    @IBAction func photo()
//    {
//        
//        Tool.shareTool.choosePicture(self, editor: true, options: .photoLibrary) {[weak self] (image) in
//            
//            self!.activityIndicatorView.startAnimating()
//            
//            DispatchQueue.global().async {
//                let recognizeResult = image.recognizeQRCode()
//                let result = recognizeResult?.characters.count > 0 ? recognizeResult : "无法识别"
//                DispatchQueue.main.async {
//                    self!.activityIndicatorView.stopAnimating()
//                    Tool.confirm(title: "扫描结果", message: result, controller: self!)
//                }
//            }
//        }
//        
//    }
//    
//    //MARK: -
//    //MARK: Data Request
//    
//    
//    //MARK: -
//    //MARK: Private Methods
//    
//    //开始扫描
//    fileprivate func startScan()
//    {
//        
//        scanLine.layer.add(scanAnimation(), forKey: "scan")
//        
//        guard let scanSession = scanSession else { return }
//        
//        if !scanSession.isRunning
//        {
//            scanSession.startRunning()
//        }
//        
//        
//    }
//    
//    //扫描动画
//    private func scanAnimation() -> CABasicAnimation
//    {
//        
//        let startPoint = CGPoint(x: scanLine .center.x  , y: 1)
//        let endPoint = CGPoint(x: scanLine.center.x, y: scanPane.bounds.size.height - 2)
//        
//        let translation = CABasicAnimation(keyPath: "position")
//        translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        translation.fromValue = NSValue(cgPoint: startPoint)
//        translation.toValue = NSValue(cgPoint: endPoint)
//        translation.duration = scanAnimationDuration
//        translation.repeatCount = MAXFLOAT
//        translation.autoreverses = true
//        
//        return translation
//    }
//    
//    
//    ///闪光灯
//    private func turnTorchOn()
//    {
//        
//        guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else
//        {
//            
//            if lightOn
//            {
//                
//                Tool.confirm(title: "温馨提示", message: "闪光灯不可用", controller: self)
//                
//            }
//            
//            return
//        }
//        
//        if device.hasTorch
//        {
//            do
//            {
//                try device.lockForConfiguration()
//                
//                if lightOn && device.torchMode == .off
//                {
//                    device.torchMode = .on
//                }
//                
//                if !lightOn && device.torchMode == .on
//                {
//                    device.torchMode = .off
//                }
//                
//                device.unlockForConfiguration()
//            }
//            catch{ }
//            
//        }
//        
//    }
//    
//    //MARK: -
//    //MARK: Dealloc
//    
//    deinit
//    {
//        ///移除通知
//        NotificationCenter.default.removeObserver(self)
//        
//    }
//    
//}
//
//
////MARK: -
////MARK: AVCaptureMetadataOutputObjects Delegate
//
////扫描捕捉完成
//extension ScanCodeViewController : AVCaptureMetadataOutputObjectsDelegate
//{
//    
//    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
//    {
//        
//        //停止扫描
//        self.scanLine.layer.removeAllAnimations()
//        self.scanSession!.stopRunning()
//        
//        //播放声音
//        Tool.playAlertSound(sound: "noticeMusic.caf")
//        
//        //扫完完成
//        if metadataObjects.count > 0
//        {
//            
//            if let resultObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject
//            {
//                
//                Tool.confirm(title: "扫描结果", message: resultObj.stringValue, controller: self,handler: { (_) in
//                    //继续扫描
//                    self.startScan()
//                })
//                
//            }
//            
//        }
//        
//    }
//    
//}
//

let kMargin = 35
let kBorderW = 140
let scanViewW = UIScreen.main.bounds.width - CGFloat(kMargin * 2)
let scanViewH = UIScreen.main.bounds.width - CGFloat(kMargin * 2)

import UIKit
import AVFoundation

class ScanCodeViewController: UIViewController {
    
    var scanView: UIView? = nil
    var scanImageView: UIImageView? = nil
    var session = AVCaptureSession()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetAnimatinon()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        setupMaskView()
        setupScanView()
        scaning()
        NotificationCenter.default.addObserver(self, selector: #selector(resetAnimatinon), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 整体遮罩设置
    fileprivate func setupMaskView() {
        let maskView = UIView(frame: CGRect(x: -(view.bounds.height - view.bounds.width) / 2, y: 0, width: view.bounds.height, height: view.bounds.height))
        maskView.layer.borderWidth = (view.bounds.height - scanViewW) / 2
        maskView.layer.borderColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.6).cgColor
        view.addSubview(maskView)
    }
    
    /// 扫描区域设置
    fileprivate func setupScanView() {
        
        scanView = UIView(frame: CGRect(x: CGFloat(kMargin), y: CGFloat((view.bounds.height - scanViewW) / 2), width: scanViewW, height: scanViewH))
        scanView?.backgroundColor = UIColor.clear
        scanView?.clipsToBounds = true
        view.addSubview(scanView!)
        
        scanImageView = UIImageView(image: UIImage.init(named: "sweep_bg_line"));
     
        
        let bgImg = UIImageView(frame: CGRect(x: 0, y: 0, width: scanViewW, height: scanViewH))
       
        bgImg.image = UIImage(named: "QRCode_ScanBox")
        scanView?.addSubview(bgImg)
        
        

    }
    
    
    /// 开始扫描
    fileprivate func scaning() {
        
        //获取摄像设备
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            //创建输入流
            let input = try AVCaptureDeviceInput.init(device: device)
            //创建输出流
            let output = AVCaptureMetadataOutput()
            output.rectOfInterest = CGRect(x: 0.1, y: 0, width: 0.9, height: 1)
            //设置代理,在主线程刷新
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            //初始化链接对象 / 高质量采集率
            session.canSetSessionPreset(AVCaptureSessionPresetHigh)
            session.addInput(input)
            session.addOutput(output)
            
            //在上面三行之后写下面代码,不然报错如下:Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[AVCaptureMetadataOutput setMetadataObjectTypes:] Unsupported type found - use -availableMetadataObjectTypes'
            //http://stackoverflow.com/questions/31063846/avcapturemetadataoutput-setmetadataobjecttypes-unsupported-type-found
            //设置扫码支持的编码格式
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]
            
            let layer = AVCaptureVideoPreviewLayer(session: session)
            layer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            layer?.frame = view.layer.bounds
            view.layer.insertSublayer(layer!, at: 0)
            //开始捕捉
            session.startRunning()
            
        } catch let error as NSError  {
            print("errorInfo\(error.domain)")
        }
    }
    
    ///重置动画
    @objc fileprivate func resetAnimatinon() {
        let anim = scanImageView?.layer.animation(forKey: "translationAnimation")
        if (anim != nil) {
            //将动画的时间偏移量作为暂停时的时间点
            let pauseTime = scanImageView?.layer.timeOffset
            //根据媒体时间计算出准确的启动时间,对之前暂停动画的时间进行修正
            let beginTime = CACurrentMediaTime() - pauseTime!
            ///便宜时间清零
            scanImageView?.layer.timeOffset = 0.0
            //设置动画开始时间
            scanImageView?.layer.beginTime = beginTime
            scanImageView?.layer.speed = 1.1
        } else {
            
            let scanImageViewH = 241
            let scanViewH = view.bounds.width - CGFloat(kMargin) * 2
            let scanImageViewW = scanView?.bounds.width
            
            scanImageView?.frame = CGRect(x: 0, y: -scanImageViewH, width: Int(scanImageViewW!), height: scanImageViewH)
            let scanAnim = CABasicAnimation()
            scanAnim.keyPath = "transform.translation.y"
            scanAnim.byValue = [scanViewH]
            scanAnim.duration = 1.8
            scanAnim.repeatCount = MAXFLOAT
            scanImageView?.layer.add(scanAnim, forKey: "translationAnimation")
            scanView?.addSubview(scanImageView!)
        }
    }
}

extension ScanCodeViewController:AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects.count > 0 {
            session.stopRunning()
            let object = metadataObjects[0]
            let string: String = (object as AnyObject).stringValue
            if let url = URL(string: string) {
                if UIApplication.shared.canOpenURL(url) {
                    _ = self.navigationController?.popViewController(animated: true)
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                    //去打开地址链接
                } else {
                    //获取非链接结果
                    let alertViewController = UIAlertController(title: "扫描结果", message: (object as AnyObject).stringValue, preferredStyle: .alert)
                    let actionCancel = UIAlertAction(title: "退出", style: .cancel, handler: { (action) in
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    let actinSure = UIAlertAction(title: "再次扫描", style: .default, handler: { (action) in
                        self.session.startRunning()
                    })
                    alertViewController.addAction(actionCancel)
                    alertViewController.addAction(actinSure)
                    self.present(alertViewController, animated: true, completion: nil)
                }
            }
        }
    }
}
