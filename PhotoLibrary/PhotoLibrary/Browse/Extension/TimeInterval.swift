//
//  TimeInterval.swift
//  PhotoLibrary
//
//  Created by 董家祎 on 2017/11/20.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import Foundation
extension TimeInterval {
    
    var time:String!{
        let second = lround(self)
        
        let minutes = (second / 60) % 60
        let hours = second / 3600
        
        if hours == 0  {
            return String(format: "%02d:%02d",minutes,second % 60)
        }
        
        
        return String(format: "%02d:%02d:%02d", hours,minutes,second % 60)
        
}
}

