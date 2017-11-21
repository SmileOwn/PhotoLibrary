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
    
    var assetListView:PhotoAssetListView?
    var titleButton:UIButton!
    //MARK:1 单选 大于1 多选
    var maxNumber:Int = 9
    
    
    //用于解决xib中colllectionView scrollToItem 无效问题
    var flag = true
    
    //MARK:相册处理类
    var albumResult:AlbumResult = AlbumResult()
    
    //MARK:用户相册文件夹集合
    var albumList:[FetchModel] {
        return albumResult.fetchs
    }
    
    //MARK:当前用户相册
    var current:FetchModel!
    
    //mark:选中的图片 或者 视频
    var selecteds:[PhotoModel] = []
    
    
    let itemWidth = (UIScreen.main.bounds.size.width - 20) / 4
    
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.current = albumList.first
        
        self.stup()
        self.reload()
        self.initNavigation()
        
    }
    //MARK:更新相册来源
    func reload() -> Void {
       
        collectionView.reloadData()
        scrollToBottom()
    }
    
    //MARK:初始化UI
    func stup() -> Void {
        collectionView.register(UINib(nibName: "AlbumCollectionCell", bundle: nil), forCellWithReuseIdentifier: "AlbumCollectionCell")
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
    
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    
    }
  
    //MARK:滚动到相册末尾
    func scrollToBottom() -> Void {
          collectionView.scrollToItem(at: IndexPath(row:current.fetchResult.count-1, section: 0), at: .top, animated: false)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //MARK:第一次加载collectionView 使其滚动到最后
        if flag {
            scrollToBottom()
            flag = false
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    

}
extension AlbumController:AlbumCollectionCellDelegate{
    
    //MARK:获取 photo下标
    func index(photo:PhotoModel) -> Int? {
        let index =  selecteds.index(where: { (model) -> Bool in
            return model.asset?.localIdentifier == photo.asset?.localIdentifier
        })
        return index
    }
    //MARK:更新相册文件夹选中状态
    func updateAlbumList() -> Void {
        if selecteds.count == 0 {
            self.current.isContains = false
        }else{
            
            let fetchModel =  self.albumList.first(where: { (model) -> Bool in
                
                return model.title == "所有照片"
            })
            
           fetchModel?.isContains = true
        }
        self.selecteds.forEach { (model) in
            
            if self.current.fetchResult.contains(model.asset!) {
                self.current.isContains = true
            }else{
                self.current.isContains = false
            }
        }
       
    }
    
    func selected(button: UIButton, photo: PhotoModel) {
        
       
        button.isSelected = !button.isSelected
        button.selectAnimation()
        
        if button.isSelected {
            selecteds.append(photo)
        }else{
            let index = self.index(photo: photo)
            
            if index != nil{
                selecteds.remove(at: index!)
            }
        
        }
       updateAlbumList()

        
    }
}
extension AlbumController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.current.count
    }
    
   
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionCell", for: indexPath) as! AlbumCollectionCell
        cell.delgate = self
        albumResult.library(index: indexPath.row, fetch: current, thumbSize: CGSize(width: itemWidth, height: itemWidth)) { (model) in
            
            var photo = model
            
            let index = self.selecteds.index(where: { (photoModel) -> Bool in
                
                return photoModel.asset?.localIdentifier == model.asset?.localIdentifier
            })
            
            if index != nil { photo.isSelected = true }
            cell.photo = photo
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
