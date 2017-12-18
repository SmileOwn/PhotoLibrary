//
//  AlbumController.swift
//  PhotoLibrary
//
//  Created by 董家祎 on 2017/11/16.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit
protocol AlbumControllerDelegate:class {
    
    func albumImages(images:[UIImage]) -> Void
    
}

class AlbumController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var previewButton: UIButton!
    
    var delegate:AlbumControllerDelegate?
    
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
    var selecteds:[PhotoModel]!{
        willSet{
            let count = newValue.count
            updateButton(count: count)
           
        }
    }
    
    
    let itemWidth = (UIScreen.main.bounds.size.width - 20) / 4
    
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = true
        selecteds = []
        self.current = albumList.first
        
        self.stup()
        self.reload()
        self.initNavigation()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    @IBAction func previewButtonAction(_ sender: Any) {
        self.pusBrowController(index: 0,type: 1)
    }
    
    
    @IBAction func finishButtonAction(_ sender: Any) {
        self.pusBrowController(index: 0,type: 1)
    }
    
    //MARK:根据选择图片数量更新 预览 完成按钮状态
    func updateButton(count:Int) -> Void {
        finishButton.updateTitle(count: count)
        previewButton.updateButton(count: count)
       
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
        
     selecteds =  AlbumCollection.selectStatus(max: self.maxNumber, selecteds: selecteds, button: button, photo: photo)
     
       updateAlbumList()

        
    }
}
extension AlbumController:PhotoBrowControllerDelegate{
    func goback(selects: [PhotoModel]) {
        self.selecteds = selects
        self.updateAlbumList()
        self.collectionView.reloadData()
    }
}

extension AlbumController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func downloadImage(cell:AlbumCollectionCell) -> Void {
        cell.photo.isProgress = true
        albumResult.downloadImage(asset: cell.photo.asset!) { (progress,error) in
            
            if error == nil {
                cell.coverLabel.text = String(Int((progress * 100))) + "%"
                if progress == 1.0 {
                    cell.photo.isICloud = false
                    cell.photo.isProgress = false
                    cell.normalStyle(model: cell.photo)
                }
            }else{
                cell.photo.isProgress = false
                cell.icloudStyle(model: cell.photo)
            }
            
            
            
        }
    }
    func pusBrowController(index:Int,type:Int) -> Void {
        let controller = PhotoBrowController()
        controller.albumResult = self.albumResult
        controller.current     = self.current
        controller.currentIndex = index
        controller.selecteds   = self.selecteds
        controller.maxNumber   = self.maxNumber
        controller.type        = type
        controller.delegate    = self
        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! AlbumCollectionCell
        
        let model = cell.photo
        if (model?.isProgress)! {
            return
        }
        if (model?.isICloud)! {
            self.downloadImage(cell: cell)
            return
        }
       
        self.pusBrowController(index: indexPath.row,type:0)
    }
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
    
    static func album(delegate:Any,max:Int) -> Void {
        let root = UIApplication.shared.keyWindow?.rootViewController
        let album = AlbumController()
        album.delegate = delegate as? AlbumControllerDelegate
        album.maxNumber = max
        let nav = UINavigationController(rootViewController: album)
       
        root?.present(nav, animated: true, completion: nil)
        

    }
}
