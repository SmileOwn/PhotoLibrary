//
//  PhotoBrowsEexten.swift
//  FlyReport
//
//  Created by 董家祎 on 2017/6/7.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import Foundation
import Photos


extension PhotoBrowseController{
    
    func navigationStatus() -> Void {
        
        let constant = self.bottomViewConstraint.constant
        
        if constant == 0 {
           
            self.hiddenNavigation()
        }else{
           self.showNaviahtion()
        }
        
    }
    func hiddenNavigation() -> Void {
        
        self.bottomViewConstraint.constant = -120
        self.topViewConstraint.constant = -60
        self.topBackViewConstraint.constant = -60
    }
    
    func showNaviahtion() -> Void {
        self.bottomViewConstraint.constant = 0
        self.topBackViewConstraint.constant = 0
        self.topViewConstraint.constant = 0
        
    }

}


extension PhotoBrowseController:BrowseCollectionCellDelegate,BrowVideoCollectionCellDelegate{
    
    func tapScrollViewAction() {
        
        self.navigationStatus()
        
    }
    
    func pauseVideoAction() {
        self.showNaviahtion()
    }
    
    func playVideoAction() {
        self.hiddenNavigation()
    }
}

extension PhotoBrowseController:ThumCollectionViewDelegate{
//    func selectThumb(assetMode: AssetModel) {
//        
//        self.collectionView.scrollToItem(at: IndexPath(item: assetMode.index, section: 0), at: .right, animated: false)
//        self.thumView.reloadData(assets: self.selectAsset, current: index)
//    }
}




extension PhotoBrowseController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    //MARK:照片 cell
    func browseCell(indexPath:IndexPath) -> BrowseCollectionCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowseCollectionCell", for: indexPath) as! BrowseCollectionCell
        
         cell.delegate = self
        
         cell.stupScrollowView()
        albumReult.libraryData(index: indexPath.row, assetsFetch: fetchModel.fetchResult) { (image, asset) in
            cell.imageView.image = image
        }

     
        return cell
        
    }
    
    //MARK: 视频 cell
    func browVideoCell(indexPath:IndexPath,asset:PHAsset) -> BrowVideoCollectionCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowVideoCollectionCell", for: indexPath) as!  BrowVideoCollectionCell
        cell.delegate = self


        albumReult.libraryVideo(index: indexPath.row, assetsFetch: self.fetchModel.fetchResult) { (item, asset) in
            cell.playerItem = item
        }
        
        return cell

    }
  
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let asset:PHAsset = self.fetchModel.fetchResult[indexPath.row]
        
        if asset.mediaType.rawValue == 2 {
            let browVideoCell = self.browVideoCell(indexPath: indexPath,asset: asset)
            return browVideoCell
        }

        let browImageCell = self.browseCell(indexPath: indexPath)
        
        return browImageCell
        
      
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
      return self.fetchModel.count
    }
    
    func pauseVideo(index:Int) -> Void {
        
        let indexPath = IndexPath(row: index, section: 0)
        let collectionCell = self.collectionView.cellForItem(at: indexPath)
        
        if collectionCell is BrowVideoCollectionCell {
            
            let videoCell = collectionCell as! BrowVideoCollectionCell
            videoCell.pause()
            
        }
        
        
    }
    
    func currenIndex(scrollView:UIScrollView) -> Void {
        let index  = lroundf(Float(scrollView.contentOffset.x / self.itemSize.width))
        
         
//        let assetModel = self.albumModel.results[index]
//        self.selectButton.isSelectedAnimation = assetModel.isSelect
//
        self.index = index
        self.pauseVideo(index: index)
    
    }
 
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         
        self.currenIndex(scrollView: scrollView)
        
        
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.currenIndex(scrollView: scrollView)
        
        //self.thumView.reloadData(assets: self.selectAsset, current: index)
    }
    
    
    

  
   
  

}
