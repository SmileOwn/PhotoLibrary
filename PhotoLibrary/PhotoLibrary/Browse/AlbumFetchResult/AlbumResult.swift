//
//  AlbumResult.swift
//  PhotoLibrary
//
//  Created by 董家祎 on 2017/11/16.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import Foundation
import Photos

enum MediaType:Int {
    case  none  = 0
    case  image = 1
    case  video = 2
    case  audio = 3
}

struct PhotoModel {
    var mediaType:MediaType = MediaType.none
    var asset:PHAsset?
    var image:UIImage?
    var isSelected:Bool = false
    var index:Int = -1
    var titleIndex:Int = 0
    
    
    
    init(asset:PHAsset,image:UIImage,index:Int) {
        self.index = index
        self.asset = asset
        self.image = image
        switch asset.mediaType.rawValue {
        case 0:
            self.mediaType = .none
            break
        case 1:
            self.mediaType = .image
            break
        case 2:
            self.mediaType = .video
            break
        case 3:
            self.mediaType = .audio
        default: break
            
            
    }
 }
}

struct FetchModel {
    var title:String = ""
    var fetchResult:PHFetchResult<PHAsset>
    var count = 0
    var coverImage:UIImage?
    
    
    init(title:String,fetch:PHFetchResult<PHAsset>) {
        self.title = title
        self.fetchResult = fetch
        self.count  = fetch.count
    }
    
}

class AlbumResult {
    
    var imageManager:PHCachingImageManager = PHCachingImageManager()
    
    init() {
      imageManager.stopCachingImagesForAllAssets()
        
      self.collections()
        
    }
    var fetchs:[FetchModel] = []
    
     var option:PHImageRequestOptions = PHImageRequestOptions()
    
    //MARK:系统智能相册
   private var smart:PHFetchResult<AnyObject>!{
        
        return PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: PHFetchOptions()) as! PHFetchResult<AnyObject>
    }
    
    //MARK:用户自定义相册
   private var userCustom:PHFetchResult<AnyObject>!{
        
        return PHCollection.fetchTopLevelUserCollections(with: nil) as! PHFetchResult<AnyObject>
    }
 
   
    //MARk:获取用户相册所有的相册集合
   private func collections() -> Void {
    
    let smarts:[FetchModel]       =  self.result(collection: smart)
   
    let userCustoms:[FetchModel]  =  self.result(collection: userCustom)
    
    self.fetchs.append(contentsOf: smarts)
    self.fetchs.append(contentsOf: userCustoms)

//      self.fetchs =   self.fetchs.flatMap { (fetchModel) -> FetchModel? in
//
//        var model = fetchModel
//
//         self.library(index: 0, assetsFetch: fetchModel.fetchResult, thumbSize: CGSize(width: 50.0, height: 50.0), result: { (image, asset) in
//
//            model.coverImage = image
//         })
//           return model
//        }
    
    
    
    }

    //MARK:遍历相册集合
    private func result(collection:PHFetchResult<AnyObject>) -> [FetchModel]! {
        
        var array:[FetchModel] = []
        
        collection.enumerateObjects { (object, index, stop) in
            
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                        ascending: true)]
            guard object is PHAssetCollection else {return}
            let   assetObject = object  as!  PHAssetCollection
            
            let  assetResuable = PHAsset.fetchAssets(in: assetObject, options: options)
            
            if   assetResuable.count > 0 &&  assetObject.localizedTitle != "最近删除" {
                
                let fetch = FetchModel(title: assetObject.localizedTitle!, fetch: assetResuable)
                array.append(fetch)
                
            }
            
        }
        
        return array
    }
    
    
    //MARK:获取图片数据
    public  func library(index:Int,assetsFetch:PHFetchResult<PHAsset>,thumbSize:CGSize,result:@escaping(_ photoModel:PhotoModel)->()) -> Void {
     
        self.library(index: index, assetsFetch: assetsFetch, thumbSize: thumbSize) { (image, asset) in
        
            let model = PhotoModel(asset: asset, image: image, index: index)
            
            result(model)
        }
    }
    
     private  func library(index:Int,assetsFetch:PHFetchResult<PHAsset>,thumbSize:CGSize,result:@escaping(_ image:UIImage,_ asset:PHAsset)->()) -> Void {
        
        let retainScale = UIScreen.main.scale
        let size =  CGSize(width: thumbSize.width * retainScale, height: thumbSize.height * retainScale)
        let asset = assetsFetch[index]
       
            self.imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil) { (image, _) in
                
                    result(image!,asset)
                
            }
        
     

    
    }
    
   static func libiray(cacheManager:PHCachingImageManager, asset:PHAsset,thumb:CGSize,result:@escaping(_ image:UIImage)->()) -> Void {
        let retainScale = UIScreen.main.scale
    
        let size =  CGSize(width: thumb.width * retainScale, height: thumb.height * retainScale)
    
        cacheManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil) { (image, _) in
            result(image!)
            
        }
        
    }
    
   
    
}














