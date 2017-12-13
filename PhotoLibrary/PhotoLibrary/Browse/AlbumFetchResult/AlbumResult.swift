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
protocol AssetProtocol {
   static var mediaType:MediaType{get}
    
}

struct PhotoModel {
    var mediaType:MediaType = MediaType.none
    var isICloud:Bool = false
    var isProgress:Bool = false
    
    var asset:PHAsset?
    var image:UIImage?
    var isSelected:Bool = false
    var titleIndex:Int = 0
    var fetchTitle:String = ""
    var index:Int = 0
    var fetchModel:FetchModel!
    
    
    
    init(asset:PHAsset,image:UIImage,fetchTitle:String,index:Int,fetch:FetchModel) {
    
        self.asset = asset
        self.image = image
        self.fetchTitle = fetchTitle
        self.index = index
        self.fetchModel = fetch
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

class FetchModel {
    var title:String = ""
    var fetchResult:PHFetchResult<PHAsset>
    var count = 0
    var coverImage:UIImage?
    
    var isContains:Bool = false
    
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

    }

    //MARK:遍历相册集合
    private func result(collection:PHFetchResult<AnyObject>) -> [FetchModel]! {
        
        var array:[FetchModel] = []
        
        collection.enumerateObjects { (object, index, stop) in
            
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                        ascending: true)]
            
            options.predicate =  NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            
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
    public  func library(index:Int,fetch:FetchModel,thumbSize:CGSize,result:@escaping(_ photoModel:PhotoModel)->()) -> Void {
     
      
        
        self.library(index: index, assetsFetch: fetch.fetchResult, thumbSize: thumbSize) { (image, asset) in
        
            var model = PhotoModel(asset: asset, image: image, fetchTitle: fetch.title,index:index,fetch:fetch)
            
            PHImageManager.default().requestImageData(for: asset, options: nil, resultHandler: { (data, str, orient, info) in
                
                let icloud = info!["PHImageResultIsInCloudKey"] as! Int
                model.isICloud = icloud == 1 ? true : false
               
                
                result(model)
            })
            
        
        }
    }
    
    
    //获取视频
    public  func libraryVideo(index:Int,assetsFetch:PHFetchResult<PHAsset>,result:@escaping(_ item:AVPlayerItem,_ asset:PHAsset)->()) -> Void{
        
        let asset = assetsFetch[index]
        
        
       self.imageManager.requestPlayerItem(forVideo: asset, options: nil) { (playerItem, _) in
            
            result(playerItem!,asset)
        }
    }
    //获取原图
    public  func libraryData(index:Int,assetsFetch:PHFetchResult<PHAsset>,result:@escaping(_ image:UIImage,_ asset:PHAsset)->()) -> Void {

        let asset = assetsFetch[index]
        
        let option = PHImageRequestOptions()
        option.resizeMode = .fast
        
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: option) { (image, info) in
            
            let isDegra = info![PHImageResultIsDegradedKey] as! Bool
            
            if  image != nil {
                result(image!,asset)
            }
            
            if isDegra == false && image == nil {
                
                let options = PHImageRequestOptions()
                options.isNetworkAccessAllowed = true
                options.resizeMode = .fast
                
                options.progressHandler = { progress, _, _, _ in
                    print("icloud同步中")
                    DispatchQueue.main.sync {
                      print(progress)
                         if progress == 1.0 {
                            print("同步完成")
                        }
                    }
                }
                
                
                PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { (imageData, _, _, _) in
                    guard let imageData = imageData else { return }
                    result(UIImage(data: imageData)!,asset)
                })
                
            }
            
        }
        
        
    }
    
    
    
    //MARK:下载原图
    public func downloadImage(asset:PHAsset,progress:@escaping(_ progress:Double,_ error:Error?)->()) -> Void {
        
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.resizeMode = .fast
        options.progressHandler = { p, error, _, _ in
            DispatchQueue.main.sync {
                
                progress(p,error)
            }
        }
        PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { (_, _, _, _) in
            
        })
        
    }
    
     private  func library(index:Int,assetsFetch:PHFetchResult<PHAsset>,thumbSize:CGSize,result:@escaping(_ image:UIImage,_ asset:PHAsset)->()) -> Void {
        
        let retainScale = UIScreen.main.scale
        let size =  CGSize(width: thumbSize.width * retainScale, height: thumbSize.height * retainScale)
        let asset = assetsFetch[index]
        let option:PHImageRequestOptions = PHImageRequestOptions()
        option.resizeMode = .fast
 
            self.imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: option) { (image, info) in
            
                
                    result(image!,asset)
                
            }
  
    
    }
    
    
   static func libiray(cacheManager:PHCachingImageManager, asset:PHAsset,thumb:CGSize,result:@escaping(_ image:UIImage)->()) -> Void {
        let retainScale = UIScreen.main.scale
    
        let size =  CGSize(width: thumb.width * retainScale, height: thumb.height * retainScale)
    
        cacheManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil) { (image, info) in
            
            
            result(image!)
            
            
            
        }
    
    }
    
   
    
}














