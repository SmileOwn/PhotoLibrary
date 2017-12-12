//
//  AlbumCollectionCell.swift
//  PhotoLibrary
//
//  Created by 董家祎 on 2017/11/16.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit
import Photos

protocol AlbumCollectionCellDelegate:class {
    func selected(button:UIButton,photo:PhotoModel) -> Void
}

class AlbumCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imgaeView: UIImageView!
    @IBOutlet weak var videoImageView: UIImageView!
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var videoLabel: UILabel!
    weak var delgate:AlbumCollectionCellDelegate?
    
    @IBOutlet weak var coverLabel: UILabel!
    var albumResult:AlbumResult!
    
    
    var photo:PhotoModel!{
        willSet{
            imgaeView.image = newValue.image
            
            if newValue.isICloud {
                self.icloudStyle(model: newValue)
            }else{
                self.normalStyle(model: newValue)
            }
           
            if newValue.mediaType != .video {
                videoImageView.isHidden = true
                videoLabel.isHidden =   true
            }else{
                videoImageView.isHidden = false
                videoLabel.isHidden = false
                videoLabel.text = newValue.asset?.duration.time
            }
            
            
        }
    }
    
    func icloudStyle(model:PhotoModel) -> Void {
        
        selectButton.setImage(UIImage(named: "isIcloud"), for: .normal)
        coverLabel.text = ""
        coverLabel.isHidden = false
        
    }
    func normalStyle(model:PhotoModel) -> Void {
        selectButton.setImage(UIImage(named: "photoNormal"), for: .normal)
        selectButton.setImage(UIImage(named: "photoSelect"), for: .selected)
        selectButton.isSelected = model.isSelected
        coverLabel.isHidden = true
    }
  
    
    @IBAction func selectButtonAction(_ sender: Any) {
       
        if photo.isICloud {
            return
        }
        self.delgate?.selected(button: selectButton, photo: photo)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

}
