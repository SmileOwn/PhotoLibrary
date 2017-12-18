//
//  PhotoBrowController.swift
//  PhotoLibrary
//
//  Created by 董家祎 on 2017/12/12.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit
import Photos



protocol PhotoBrowControllerDelegate:class {
    
    func goback(selects:[PhotoModel]) -> Void
    
}
class PhotoBrowController: UIViewController {

    var albumResult:AlbumResult!
    var current:FetchModel!
    var currentIndex:Int = 0
    var isShowNav:Bool = true
    var selecteds:[PhotoModel]!
    var maxNumber:Int = 0
    //0 点击cell 进入 1预览
    var type:Int = 0
    var selectsCopy:[PhotoModel]!
    
   weak var delegate:PhotoBrowControllerDelegate?
    
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var layout: BlowFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.collectionView.register(UINib(nibName: "BlowCollectionCell", bundle: nil), forCellWithReuseIdentifier: "BlowCollectionCell")
     
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing      = 0
        self.collectionView.isPagingEnabled = true
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.size.width+20, height: UIScreen.main.bounds.size.height)
        
        if self.type == 0 {
            
            self.collectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .right, animated: false)
        }else{
            self.selectsCopy = selecteds
        }
       
        
        self.updateTitle()
      
    }
    //MARK:获取 photo下标
    func index(photo:PhotoModel) -> Int? {
        let index =  selecteds.index(where: { (model) -> Bool in
            return model.asset?.localIdentifier == photo.asset?.localIdentifier
        })
        return index
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
   
    @IBAction func finishButtonAction(_ sender: Any) {
        
       
    }
    @IBAction func selectButtonAction(_ sender: Any) {
     
        var model = PhotoModel()
            model.asset = current.fetchResult[currentIndex]
        
        
   selecteds =  AlbumCollection.selectStatus(max: self.maxNumber, selecteds: selecteds, button: self.selectButton, photo: model)
          self.finishButton.updateTitle(count: self.selecteds.count)
      
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.delegate?.goback(selects: selecteds)
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

}

extension PhotoBrowController:BrowseCollectionCellDelegate{
    func tapScrollViewAction() {
        self.isShowNav = !self.isShowNav
        
        UIView.animate(withDuration: 0.3) {
            self.navView.alpha = self.isShowNav == true ? 1.0 : 0.0
        }
        
        
    }
}
extension PhotoBrowController:UICollectionViewDelegate,UICollectionViewDataSource{
   
    func updateTitle() -> Void {
        self.titleLabel.text = String(currentIndex+1) + "/" + String(current.count)
        var asset:PHAsset? = nil
        
        if self.type == 1 {
            asset = selectsCopy[currentIndex].asset
        }else{
             asset = current.fetchResult[currentIndex]
        }
        let assets =  selecteds.flatMap { (model) -> String? in
            
            return model.asset?.localIdentifier
        }
        self.selectButton.isSelected = assets.contains((asset?.localIdentifier)!)
        
        self.finishButton.updateTitle(count: selecteds.count)
    }
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.currentIndex =   lroundf(Float(scrollView.contentOffset.x / self.layout.itemSize.width))
        
        self.updateTitle()
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.currentIndex =   lroundf(Float(scrollView.contentOffset.x / self.layout.itemSize.width))
        
        self.updateTitle()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
       
        return self.type == 1 ? self.selectsCopy.count : current.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlowCollectionCell", for: indexPath) as! BlowCollectionCell
        cell.delegate = self
        cell.stupScrollowView()
       
        if self.type == 1 {
            let photo = selectsCopy[indexPath.row]
            
            albumResult.masterImage(photo.asset!, { (image, asset) in
                cell.imageView.image = image
            })
            
            return cell
        }
        albumResult.libraryData(index: indexPath.row, assetsFetch: current.fetchResult) { (image, asset) in
            
            cell.imageView.image = image
            
        }
        return cell
        
    }

}
