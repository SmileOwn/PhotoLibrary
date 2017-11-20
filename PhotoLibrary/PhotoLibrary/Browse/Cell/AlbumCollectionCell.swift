//
//  AlbumCollectionCell.swift
//  PhotoLibrary
//
//  Created by 董家祎 on 2017/11/16.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit

class AlbumCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imgaeView: UIImageView!
    @IBOutlet weak var videoImageView: UIImageView!
    
    @IBOutlet weak var videoLabel: UILabel!
    var photo:PhotoModel!{
        willSet{
            imgaeView.image = newValue.image
            if newValue.mediaType != .video {
                videoImageView.isHidden = true
                videoLabel.isHidden =   true
            }else{
                videoImageView.isHidden = false
                videoLabel.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
