//
//  GenerateQRCodeViewController.swift
//  YMQRCodeDemo
//
//  Created by YDWY on 2017/5/6.
//  Copyright © 2017年 YDWY. All rights reserved.
//

import UIKit

class GenerateQRCodeViewController: UIViewController {

    
    //MARK: -
    //MARK: Global Variables
    
    @IBOutlet private weak var contentLab: UITextField!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var QRCodeImageView: UIImageView!
    
    //MARK: -

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        setupComponents()
        
    }
    
    
    //MARK: -
    //MARK: Interface Components
    
    private func setupComponents()
    {
        
        let generateItem = UIBarButtonItem(title: "生成", style: .plain, target: self, action: #selector(generateItemClick))
        navigationItem.rightBarButtonItem = generateItem
        
        let chooseLogoGes = UITapGestureRecognizer(target: self, action: #selector(chooseLogo))
        logoImageView.addGestureRecognizer(chooseLogoGes)
        
    }
    
    //MARK: -
    //MARK: Target Action
    
    @objc private func generateItemClick()
    {
        
        view.endEditing(true)
        
        guard let  content = contentLab.text else
        {
            
            Tool.confirm(title: "温馨提示", message: "请输入内容", controller: self)
            
            return
        }
        
        if content.characters.count > 0
        {
            DispatchQueue.global().async {
                
                let image = content.generateQRCodeWithLogo(logo: self.logoImageView.image)
                DispatchQueue.main.async(execute: {
                    self.QRCodeImageView.image = image
                })
                
            }
            
        }
        else
        {
            
            Tool.confirm(title: "温馨提示", message: "请输入内容", controller: self)
            
        }
        
        
    }
    
    @objc private func chooseLogo()
    {
        
        Tool.shareTool.choosePicture(self, editor: true) { [weak self] (image) in
            self?.logoImageView.image = image
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        view.endEditing(true)
        
    }
    

    
    
}




