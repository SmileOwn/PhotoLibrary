//
//  PhotoBrowseController.swift
//  FlyReport
//
//  Created by 董家祎 on 2017/6/6.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit



class PhotoBrowseController: UIViewController {

    
    var albumReult:AlbumResult!
    var selecteds:[PhotoModel]!
    
    var index:Int = 0
   
    var maxNumber:Int!
    
    @IBOutlet weak var finishButton: UIButton!
    var fetchModel:FetchModel!
    
 
    
    
    
    @IBOutlet weak var selectButton: UIButton!
    
    
    var itemSize:CGSize = CGSize(width: UIScreen.main.bounds.width+20, height: UIScreen.main.bounds.height)
    
    @IBOutlet weak var topBackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var topViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var thumView: ThumCollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.collectionView.frame = CGRect(x: -10, y: 0, width: UIScreen.main.bounds.width + 20, height: UIScreen.main.bounds.size.height)
        
        layout.scrollDirection = .horizontal
        layout.itemSize = self.itemSize
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.white
        
        self.collectionView.register(UINib(nibName: "BrowseCollectionCell", bundle: nil), forCellWithReuseIdentifier: "BrowseCollectionCell")
       
        self.collectionView.register(UINib(nibName: "BrowVideoCollectionCell", bundle: nil), forCellWithReuseIdentifier: "BrowVideoCollectionCell")
        
        self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: false)
        
//        self.thumView.delegate = self
//        self.thumView.album = self.album
//        self.thumView.albumModel = self.albumModel
//        self.finishButton.setTitle("完成("+self.selectAsset.count.toString+")", for: .normal)
//        self.thumView.reloadData(assets: self.selectAsset,current: self.index)
//
        self.thumView.reloadData(assets: self.selecteds, current: self.index)
        self.finishButton.setTitle("完成(" + String(self.selecteds.count) + ")", for: .normal)
        
    }
    
   private func reloadData() -> Void {
        
//        let asset =  self.albumModel.results[self.index]
//
//        self.selectAsset =   PhotoSelectResult.selectAsset(asset: asset, button: self.selectButton, assets: self.selectAsset, maxNumber: self.maxNumber)
//
//        self.album =  PhotoSelectResult.album(assetsSelect: self.selectAsset, album: self.album)
//
//        self.thumView.reloadData(assets: self.selectAsset,current: self.index)
//
//        self.finishButton.setTitle("完成("+self.selectAsset.count.toString+")", for: .normal)
    
    
    
    }
  
 
   
    @IBAction func goBackAction(_ sender: Any) {
       
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonAction(_ sender: UIButton) {
      
        self.reloadData()
        
    }
    
    
    @IBAction func finishAction(_ sender: Any) {
      
        
        self.navigationController?.popViewController(animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.setStatusBarHidden(true, with: .none)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        UIApplication.shared.setStatusBarHidden(false, with: .none)
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
}

