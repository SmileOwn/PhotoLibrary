//
//  BrowseCollectionCell.swift
//  FlyReport
//
//  Created by 董家祎 on 2017/6/7.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit
import Photos

protocol BrowseCollectionCellDelegate:class {
    
    func tapScrollViewAction() -> Void
    
}

class BrowseCollectionCell: UICollectionViewCell {

    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var right: NSLayoutConstraint!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var left: NSLayoutConstraint!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
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
    
    func updateConstraint() {
        if let image = imageView.image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            
            let viewWidth = scrollView.bounds.size.width-10
            let viewHeight = scrollView.bounds.size.height
            
            var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
            if hPadding < 0 { hPadding = 0 }
            
            var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
            if vPadding < 0 { vPadding = 0 }
            
            left.constant = hPadding
            right.constant = hPadding
            
            top.constant = vPadding
            bottom.constant = vPadding
            
            self.layoutIfNeeded()
        }
    }

   
}
extension BrowseCollectionCell:UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      
      
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
      
        
        
       self.updateConstraint()
    
        
    }

  
}
