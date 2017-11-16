//
//  AlbumResult.swift
//  PhotoLibrary
//
//  Created by 董家祎 on 2017/11/16.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import Foundation
import Photos

struct FetchModel {
    var title:String = ""
    var fetchResult:PHFetchResult<PHAsset>
    
    init(title:String,fetch:PHFetchResult<PHAsset>) {
        self.title = title
        self.fetchResult = fetch
    }
    
}

class AlbumResult {
    
    init() {
      self.collections()
    }
    var fetchs:[FetchModel] = []
    
    //MARK:系统智能相册
   private var smart:PHFetchResult<AnyObject>!{
        
        return PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: PHFetchOptions()) as! PHFetchResult<AnyObject>
    }
    
    //MARK:用户自定义相册
   private var userCustom:PHFetchResult<AnyObject>!{
        
        return PHCollection.fetchTopLevelUserCollections(with: nil) as! PHFetchResult<AnyObject>
    }
 
   
   private func collections() -> Void {
        self.result(collection: smart)
        self.result(collection: userCustom)
    }

    
    private func result(collection:PHFetchResult<AnyObject>) -> Void {
        
        collection.enumerateObjects { (object, index, stop) in
            
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                        ascending: true)]
            guard object is PHAssetCollection else {return}
            let   assetObject = object  as!  PHAssetCollection
            
            let  assetResuable = PHAsset.fetchAssets(in: assetObject, options: options)
            
            if   assetResuable.count > 0 &&  assetObject.localizedTitle != "最近删除" {
                
                let fetch = FetchModel(title: assetObject.localizedTitle!, fetch: assetResuable)
                self.fetchs.append(fetch)
                
            }
            
        }
        
    }
    
    
    
}














