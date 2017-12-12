//
//  PhotoBrowController.swift
//  PhotoLibrary
//
//  Created by 董家祎 on 2017/12/12.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit

class PhotoBrowController: UIViewController {

    @IBOutlet weak var layout: BlowFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "BlowCollectionCell", bundle: nil), forCellWithReuseIdentifier: "BlowCollectionCell")
     
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing      = 10
    
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height-64)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

}
extension PhotoBrowController:UICollectionViewDelegate,UICollectionViewDataSource{
   
 
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlowCollectionCell", for: indexPath)
        cell.backgroundColor = UIColor.yellow
        return cell
        
    }

}
