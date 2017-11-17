//
//  AlbumControllerExtension.swift
//  PhotoLibrary
//
//  Created by 董家祎 on 2017/11/17.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit
extension AlbumController{
    public func initNavigation() -> Void {
        
        self.leftItem(title: "取消")
        self.rightItem(title: "完成")
        self.titleView()
    }
    
    fileprivate func titleView() -> Void {
        
       let  titleButton = UIButton()
      
        titleButton.isSelected = false
        titleButton.setTitleColor(UIColor.black, for: .normal)
        titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        titleButton.setImage(UIImage(named: "photo_down"), for: .normal)
        titleButton.setImage(UIImage(named: "photo_up"), for: .selected)
        titleButton.frame = CGRect(x: 0, y: 0, width: 120, height: 44)
        titleButton.addTarget(self, action: #selector(self.titleAction(button:)), for: .touchUpInside)
        titleButton.setTitle(self.current.title, for: .normal)
        self.navigationItem.titleView = titleButton
        
        
    }
    fileprivate func leftItem(title:String) -> Void {
        let cancleButton = UIButton()
        cancleButton.setTitle(title, for: .normal)
        cancleButton.setTitleColor(UIColor.black, for: .normal)
        cancleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancleButton.frame = CGRect(x: 0, y: 0, width: 45, height: 30)
        cancleButton.addTarget(self, action: #selector(cancleAction), for: .touchUpInside)
        let leftItemBar = UIBarButtonItem(customView: cancleButton)
        self.navigationItem.leftBarButtonItem = leftItemBar
        
    }
    
    fileprivate func rightItem(title:String) -> Void {
        let finishButton = UIButton()
        finishButton.setTitle(title, for: .normal)
        finishButton.setTitleColor(UIColor.black, for: .normal)
        finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        finishButton.frame = CGRect(x: 0, y: 0, width: 45, height: 30)
        finishButton.addTarget(self, action: #selector(finishAction), for: .touchUpInside)
        let rightItemBar = UIBarButtonItem(customView: finishButton)
        self.navigationItem.rightBarButtonItem = rightItemBar
        
    }
    @objc func titleAction(button:UIButton) -> Void {
        button.isSelected = !button.isSelected
        
    
        
    }
    @objc func cancleAction() -> Void {
        self.dismiss(animated: true, completion: nil)
        
    }
    @objc func finishAction() -> Void {
        
    }
        
}