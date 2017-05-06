//
//  MyQRCodeViewController.swift
//  YMQRCodeDemo
//
//  Created by YDWY on 2017/5/6.
//  Copyright © 2017年 YDWY. All rights reserved.
//

import UIKit

class MyQRCodeViewController: UIViewController {

   
    
    var myQRCode: UIImageView!
    

    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        setupUI()
        
        
        
        myQRCode.image = "https://github.com/fuaiyi/QRCode.git".generateQRCodeWithLogo(logo: UIImage(named: "8_150709170804_8"))
        
    }
    
    private func setupUI(){
        myQRCode = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        myQRCode.center  = view.center
        view.addSubview(myQRCode)
        
        
    }
    

}
