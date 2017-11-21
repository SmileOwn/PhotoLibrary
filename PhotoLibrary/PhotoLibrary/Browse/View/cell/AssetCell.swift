//
//  AssetCell.swift
//  FlyReport
//
//  Created by 董家祎 on 2017/6/7.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit
import Photos

class AssetCell: UITableViewCell {
    var manager:PHCachingImageManager = PHCachingImageManager()
    
    
    @IBOutlet weak var titleImageView: UIImageView!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var markImageView:UIImageView = UIImageView()
    
    
    var model:FetchModel!{
        
        willSet{
            
            titleLabel.text = newValue.title
            countLabel.text = String(newValue.count)
         
            AlbumResult.libiray(cacheManager: manager, asset:  newValue.fetchResult.firstObject!, thumb: titleImageView.frame.size) { (image) in
                
                self.titleImageView.image = image
            }
            markImageView.isHidden = !newValue.isContains
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        markImageView.frame = CGRect(x: titleImageView.frame.size.width-17, y: 2, width: 15, height: 15)
        markImageView.image = UIImage(named: "mark")
        self.titleImageView.addSubview(markImageView)
        manager.stopCachingImagesForAllAssets()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
