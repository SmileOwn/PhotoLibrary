//
//  AlbumCollection.swift
//  PhotoLibrary
//
//  Created by 董家祎 on 2017/12/18.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import Foundation
import UIKit
import Photos
class AlbumCollection {
    
   static func selectStatus(max:Int,selecteds:[PhotoModel],button:UIButton,photo:PhotoModel) -> [PhotoModel] {
        
        var photos:[PhotoModel] = selecteds
        
        
        if selecteds.count == max && button.isSelected == false {
            
            return photos
        }
        button.isSelected = !button.isSelected
        button.selectAnimation()
        
        if button.isSelected {
            photos.append(photo)
        }else{
            let index = photos.index(where: { (model) -> Bool in
                
                return model.asset?.localIdentifier == photo.asset?.localIdentifier
            })
            if index != nil {
                photos.remove(at: index!)
            }
            
            
        }
        
        return photos
    }
    
}
