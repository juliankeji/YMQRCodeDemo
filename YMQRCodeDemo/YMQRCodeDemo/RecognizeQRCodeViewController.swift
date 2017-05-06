//
//  RecognizeQRCodeViewController.swift
//  YMQRCodeDemo
//
//  Created by YDWY on 2017/5/6.
//  Copyright © 2017年 YDWY. All rights reserved.
//

import UIKit

class RecognizeQRCodeViewController: UIViewController {

    var sourceImage : UIImage?
    var sourceImageView : UIImageView!
    var activityIndicatoryView: UIActivityIndicatorView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        setupUI()
        
        setupImage()
        
        setupGes()
        
    }
    
    
    
    
    //MARK: -
    //MARK: 创建视图
    private func setupUI(){
        sourceImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        sourceImageView.center = view.center
        sourceImageView.image = sourceImage
        view.addSubview(sourceImageView)
        
        
        activityIndicatoryView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatoryView.center = view.center
        view.addSubview(activityIndicatoryView)
        
    }
    
    
    //MARK: -
    //MARK: Interface Components
    
    private func setupGes()
    {
        
        sourceImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseImage)))
        
    }
    
    private func setupImage()
    {
        
        sourceImageView.image = sourceImage
        recognizeQRCode()
        
    }
    
    //MARK: -
    //MARK: Target Action
    
    @objc private func chooseImage()
    {
        
        Tool.shareTool.choosePicture(self, editor: false) { [weak self] (image) in
            self?.sourceImage = image
            self?.setupImage()
        }
        
    }
    
    //MARK: -
    //MARK: Data Request
    
    
    //MARK: -
    //MARK: Private Methods
    
    private func recognizeQRCode()
    {
        
        activityIndicatoryView.startAnimating()
        
        DispatchQueue.global().async {
            let recognizeResult = self.sourceImage?.recognizeQRCode()
            let result = recognizeResult?.characters.count > 0 ? recognizeResult : "无法识别"
            DispatchQueue.main.async {
                Tool.confirm(title: "扫描结果", message: result, controller: self)
                self.activityIndicatoryView.stopAnimating()
            }
        }
        
        
        
    }
    
    //MARK: -
    //MARK: Dealloc

}
