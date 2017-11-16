//
//  AlbumController.swift
//  PhotoLibrary
//
//  Created by 董家祎 on 2017/11/16.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit

class AlbumController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension AlbumController{
    
    static func album() -> Void {
        let root = UIApplication.shared.keyWindow?.rootViewController
        let nav = UINavigationController(rootViewController: AlbumController())
        root?.present(nav, animated: true, completion: nil)
        

    }
}
