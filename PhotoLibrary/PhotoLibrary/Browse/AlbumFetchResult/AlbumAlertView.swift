//
//  AlbumAlertView.swift
//  PhotoLibrary
//
//  Created by 董家祎 on 2017/12/19.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit

class AlbumAlertView: UIView {
      var hud:UIVisualEffectView = UIVisualEffectView()
    
    
    override init(frame: CGRect) {
          super.init(frame: frame)
    
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
  
    
    func hudView() -> Void {
        
        hud.layer.masksToBounds = true
        
        hud.autoresizingMask = UIViewAutoresizing.flexibleBottomMargin.union(.flexibleTopMargin).union(.flexibleRightMargin).union(.flexibleLeftMargin)
       
        self.addSubview(hud)
        
        hud.layer.cornerRadius = 10
        hud.backgroundColor = UIColor.black
        hud.frame = CGRect(x: 0, y: 0, width: 157, height: 80)
        hud.center = self.center
        
        
        let imageView = UIImageView()
        var imgae =  UIImage(named: "info")
        imgae = imgae?.withRenderingMode(.alwaysTemplate)
        imageView.image = imgae
       
        imageView.tintColor = UIColor.white
        hud.contentView.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        imageView.center = CGPoint(x: hud.contentView.center.x, y: hud.contentView.center.y-14)
        
        
    }
 
    static func show(superView:UIView) -> Void {
    
        let alertView = AlbumAlertView(frame: CGRect(x: 0, y: 0, width: (superView.frame.size.width), height: (superView.frame.size.height)))

        alertView.hudView()
    
        superView.addSubview(alertView)
    
    }
}
