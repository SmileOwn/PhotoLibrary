//
//  PhotoBrowController.swift
//  PhotoLibrary
//
//  Created by 董家祎 on 2017/12/12.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit

class PhotoBrowController: UIViewController {

    var albumResult:AlbumResult!
    var current:FetchModel!
    var currentIndex:Int = 0
    var isShowNav:Bool = true
    
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
        self.collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .right, animated: false)
        
        self.updateTitle()
      
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
   
    @IBAction func backButtonAction(_ sender: Any) {
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
        self.titleLabel.text = String(currentIndex) + "/" + String(current.count)
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
        
        return self.current.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlowCollectionCell", for: indexPath) as! BlowCollectionCell
        cell.delegate = self
        cell.stupScrollowView()
        
        albumResult.libraryData(index: indexPath.row, assetsFetch: current.fetchResult) { (image, asset) in
            
            cell.imageView.image = image
            
        }
        return cell
        
    }

}
