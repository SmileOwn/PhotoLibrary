//
//  BlowCollectionCell.swift
//  PhotoLibrary
//
//  Created by 董家祎 on 2017/12/12.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit

protocol BrowseCollectionCellDelegate:class {
    
    func tapScrollViewAction() -> Void
    
}

class BlowCollectionCell: UICollectionViewCell {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var right: NSLayoutConstraint!
    @IBOutlet weak var left: NSLayoutConstraint!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate:BrowseCollectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapScrollViewAction))
        scrollView.addGestureRecognizer(tapGesture)
        
    }
   @objc func tapScrollViewAction() -> Void {
        self.delegate?.tapScrollViewAction()
    }
    
    func stupScrollowView() -> Void {
        
        scrollView.scrollsToTop = false
        scrollView.isMultipleTouchEnabled = true
        scrollView.maximumZoomScale = 2.5
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
    }
    


}
extension BlowCollectionCell:UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
  
    
    
}

