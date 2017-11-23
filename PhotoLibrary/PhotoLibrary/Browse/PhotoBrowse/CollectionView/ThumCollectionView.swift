//
//  ThumCollectionView.swift
//  FlyReport
//
//  Created by 董家祎 on 2017/7/11.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit

protocol ThumCollectionViewDelegate:class {
   
}

class ThumCollectionView: UIView {

    
    var selecteds:[PhotoModel] = []
    
    var collectionView:UICollectionView!
    var layout : UICollectionViewFlowLayout!
  
    var currentIndex:Int = 0
    
   weak var delegate:ThumCollectionViewDelegate?
    
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.stupView()
        
    }
    

  
    required init?(coder aDecoder: NSCoder) {
       // fatalError("init(coder:) has not been implemented")
      
       super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.stupView()
    }
   
  
    func reloadData(assets:[PhotoModel],current:Int) -> Void {
        self.currentIndex = current
        
        self.selecteds = assets
       
        self.collectionView.reloadData()
        let item = selecteds.count - 1
        
        if item > 0 {
            self.collectionView.scrollToItem(at: IndexPath(item: item, section: 0), at: .right, animated: true)
        }
        
        
    }
    
    func stupView() -> Void {
        
        self.layout = UICollectionViewFlowLayout()
        
        self.collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.layout)
        self.addSubview(self.collectionView)
        
        self.collectionView.register(UINib(nibName: "BrowseThumColltionCell", bundle: nil), forCellWithReuseIdentifier: "BrowseThumColltionCell")
       
        self.layout.scrollDirection = .horizontal
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        layout.itemSize = CGSize(width: 60, height: 60);
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
    }
    
}

extension ThumCollectionView: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowseThumColltionCell", for: indexPath) as! BrowseThumColltionCell
       
        let photoModel = selecteds[indexPath.row]
        cell.model = photoModel
        
//
//        if self.currentIndex == assetModel.index {
//            cell.imageView.layer.borderWidth = 1
//            cell.imageView.layer.borderColor = UIColor.green.cgColor
//        }else{
//            cell.imageView.layer.borderWidth = 0
//            cell.imageView.layer.borderColor = UIColor.clear.cgColor
//        }
//        
        return cell
       
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
     
       return selecteds.count
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
 
}
