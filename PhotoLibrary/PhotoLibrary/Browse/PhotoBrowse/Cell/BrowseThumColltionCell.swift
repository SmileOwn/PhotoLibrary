//
//  BrowseThumColltionCell.swift
//  FlyReport
//
//  Created by 董家祎 on 2017/7/10.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit

class BrowseThumColltionCell: UICollectionViewCell {

    @IBOutlet weak var audioImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!

    var model:PhotoModel!{
        willSet{
            self.imageView.image = newValue.image
            if newValue.mediaType == .video {
                self.audioImageView.isHidden = false
            }else{
                self.audioImageView.isHidden = true
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.layer.borderWidth = 1
        self.imageView.layer.borderColor = UIColor.green.cgColor
        // Initialization code
    }

}
