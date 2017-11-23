//
//  BrowVideoCollectionCell.swift
//  FlyReport
//
//  Created by 董家祎 on 2017/7/12.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import MediaPlayer


protocol BrowVideoCollectionCellDelegate:class {
    
    
    
    func pauseVideoAction() -> Void
    
    func playVideoAction() -> Void
    
}

class BrowVideoCollectionCell: UICollectionViewCell {

    @IBOutlet weak var playerView: UIView!
    var isPause:Bool  = true // 默认为暂停状态  false 为播放状态
    
    
    @IBOutlet weak var playImagerView: UIImageView!
   weak var delegate:BrowVideoCollectionCellDelegate?
    
    
    private var player          :       AVPlayer?
   
    private var playerLayer     :       AVPlayerLayer?
 
    
        var playerItem      :       AVPlayerItem?{
        willSet{
        
            self.initPlayer(item: newValue!)
            
        }
    }
    
    
    func reset() -> Void {
        self.playerItem = nil
        
        self.playerLayer?.removeFromSuperlayer()
        self.player = nil
        self.playerLayer = nil
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapPlayerView = UITapGestureRecognizer(target: self, action: #selector(tapPlayerViewAction))
        self.playerView.addGestureRecognizer(tapPlayerView)
        
    }
    @objc func tapPlayerViewAction() -> Void {
       
      self.playStatus()
    }
    
    func initPlayer(item:AVPlayerItem) -> Void {

        
        DispatchQueue.main.async {
            
            self.stupAvplayer(item: item)
            
        }
        
    }
    
    func stupAvplayer(item:AVPlayerItem) -> Void {
      
        if self.player != nil {
            self.player?.replaceCurrentItem(with: item)
        }else{
             self.player = AVPlayer(playerItem: item)
        }
       
        self.playerLayer = AVPlayerLayer(player: self.player!)
        
        self.playerView.layer.insertSublayer(self.playerLayer!, at: 0)
        self.playerLayer?.frame = self.playerView.bounds
        
        self.addNotification(item: item)
        
    }
    
    func addNotification(item:AVPlayerItem) -> Void {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidPlayToEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemPlaybackStalled), name: NSNotification.Name.AVPlayerItemPlaybackStalled, object: item)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActivity), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }

   /** 程序进入后台 */
    @objc func appWillResignActivity() -> Void {
        self.pause()
    }
    /** 播放完毕通知 */
    @objc fileprivate func playerItemDidPlayToEnd() {
     
        player?.seek(to: kCMTimeZero)
        
        self.pause()
    }
    
    /** 播放异常中断通知 */
    @objc fileprivate func playerItemPlaybackStalled() {
            self.pause()
        
    }
  
  
    func playStatus() -> Void {
        if self.isPause == true {
            self.play()
        }else{
         self.pause()
        }
        
    }
    
    func play() -> Void {
        self.player?.play()
        self.playImagerView.isHidden = true
        self.isPause = false
        self.delegate?.playVideoAction()
    }
    
    func pause() -> Void {
        self.player?.pause()
        self.playImagerView.isHidden = false
        self.isPause = true
        self.delegate?.pauseVideoAction()
    }
    
    
    
    
    
    
    
}
