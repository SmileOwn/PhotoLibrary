//
//  AlbumCollectionCell.swift
//  PhotoLibrary
//
//  Created by 董家祎 on 2017/11/16.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit

protocol AlbumCollectionCellDelegate:class {
    func selected(button:UIButton,photo:PhotoModel) -> Void
}

class AlbumCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imgaeView: UIImageView!
    @IBOutlet weak var videoImageView: UIImageView!
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var videoLabel: UILabel!
    weak var delgate:AlbumCollectionCellDelegate?
    
    
    var photo:PhotoModel!{
        willSet{
            imgaeView.image = newValue.image
          selectButton.isSelected = newValue.isSelected
            
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
    
    @IBAction func selectButtonAction(_ sender: Any) {
        selectButton.isSelected = !selectButton.isSelected
        photo.isSelected = selectButton.isSelected
        selectButton.selectAnimation()
        self.delgate?.selected(button: selectButton, photo: photo)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

}
