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
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stup()
        AlbumResult()
    }
    
    //MARK:初始化UI
    func stup() -> Void {
        self.collectionView.register(UINib(nibName: "AlbumCollectionCell", bundle: nil), forCellWithReuseIdentifier: "AlbumCollectionCell")
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        let itemWidth = (self.view.frame.size.width-20) / 4
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    

}
extension AlbumController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 100
    }
    
   
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionCell", for: indexPath)
        cell.backgroundColor = UIColor.yellow
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
