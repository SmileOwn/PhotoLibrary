//
//  BlowFlowLayout.swift
//  PhotoLibrary
//
//  Created by 董家祎 on 2017/12/12.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit

class BlowFlowLayout: UICollectionViewFlowLayout {

  
 
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        let itemIndex = (self.collectionView?.contentOffset.x)! / (self.itemSize.width + 10)
        
        let index = CGFloat(Int(roundf(Float(itemIndex))))
        
        let x = UIScreen.main.bounds.size.width * index + index  * 10
        var temp = proposedContentOffset
        temp.x = x
      
        
        return super.targetContentOffset(forProposedContentOffset:temp, withScrollingVelocity: velocity)
       
        
    }
}
