//
//  Animation.swift
//  PhotoLibrary
//
//  Created by 董家祎 on 2017/11/20.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit
protocol ButtonScanAnimationProtocol {}
extension ButtonScanAnimationProtocol where Self:UIButton{
    func selectAnimation() {
        
        self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7);
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: .curveEaseIn, animations: {
            self.transform  = CGAffineTransform(scaleX: 1, y: 1);
            
        }) { (falg)in}}
    
    
    
    
}
extension UIButton:ButtonScanAnimationProtocol{}

