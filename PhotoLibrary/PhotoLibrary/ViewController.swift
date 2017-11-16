//
//  ViewController.swift
//  PhotoLibrary
//
//  Created by 董家祎 on 2017/11/16.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func photoButtonAction(_ sender: Any) {
        AlbumController.album()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

