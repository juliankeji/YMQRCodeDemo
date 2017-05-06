//
//  ViewController.swift
//  YMQRCodeDemo
//
//  Created by YDWY on 2017/5/6.
//  Copyright © 2017年 YDWY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var sourceImage : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "我的二维码", style:.plain, target: self, action: #selector(click))
        
        
    }
    
    @objc private  func click() -> () {
        self.navigationController?.pushViewController(MyQRCodeViewController(), animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
     //扫描二维码
    

    @IBAction func recognizeQRCodeClick(_ sender: Any) {
        
        let vc  = ScanCodeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //识别二维码
    @IBAction func scanQRCodeClick(_ sender: Any) {
        Tool.shareTool.choosePicture(self, editor: true) { [weak self](image) in
            self?.sourceImage = image
            let vc = RecognizeQRCodeViewController()
            vc.sourceImage = image
            self?.navigationController?.pushViewController(vc, animated: true)
        }

        
    }

    //创建二维码
    @IBAction func mackQRCodeClick(_ sender: Any) {
        let vc = GenerateQRCodeViewController()
        
         self.navigationController?.pushViewController(vc, animated: true)
    }
}

