//
//  AlbumController.swift
//  PhotoLibrary
//
//  Created by 董家祎 on 2017/11/16.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit

class AlbumController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var flag = true
    
    //MARK:用户相册文件夹集合
    var albumResult:AlbumResult = AlbumResult()
    
    var albumList:[FetchModel] {
        return albumResult.fetchs
    }
    
    var current:FetchModel!
    
    let itemWidth = (UIScreen.main.bounds.size.width - 20) / 4
    
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.current = albumList.first
        self.stup()
        
    }
    
    //MARK:初始化UI
    func stup() -> Void {
        
        
        self.collectionView.register(UINib(nibName: "AlbumCollectionCell", bundle: nil), forCellWithReuseIdentifier: "AlbumCollectionCell")
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    
    }
  
    
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if flag {
            collectionView.scrollToItem(at: IndexPath(row:self.current.fetchResult.count-1, section: 0), at: .top, animated: false)
            flag = false
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    

}
extension AlbumController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.current.count
    }
    
   
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionCell", for: indexPath) as! AlbumCollectionCell
        cell.backgroundColor = UIColor.yellow
        albumResult.library(index: indexPath.row, assetsFetch: current.fetchResult, thumbSize: CGSize(width: itemWidth/2, height: itemWidth/2)) { (image, asset) in
            
            cell.imgaeView.image  = image
            
        }
        return cell
    }
    
}
extension AlbumController{
    
    static func album() -> Void {
        let root = UIApplication.shared.keyWindow?.rootViewController
        let nav = UINavigationController(rootViewController: AlbumController())
       
        root?.present(nav, animated: true, completion: nil)
        

    }
}
