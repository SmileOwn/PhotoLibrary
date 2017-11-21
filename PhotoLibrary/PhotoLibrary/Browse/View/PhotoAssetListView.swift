//
//  PhotoAssetListView.swift
//  FlyReport
//
//  Created by 董家祎 on 2017/6/7.
//  Copyright © 2017年 董家祎. All rights reserved.
//

import UIKit

protocol PhotoAssetListViewDelegate:class {
    func cancle() -> Void
    func selected(model:FetchModel) -> Void
    
}


class PhotoAssetListView: UIView {

    var backView = UIView()
    var tableView = UITableView()
    var tableHeight:CGFloat = (UIScreen.main.bounds.size.height-64) * 0.6
    var dataSource:[FetchModel] = []
    
    weak var delegate:PhotoAssetListViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(frame:CGRect,list:[FetchModel]) {
        self.init(frame: frame)
        
        self.stupView(frame: frame, list: list)
    }
    func stupView(frame:CGRect,list:[FetchModel]) -> Void {
        
    
        backView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        backView.alpha = 0.0
        backView.backgroundColor = UIColor.black
        let tapBackGesture = UITapGestureRecognizer(target: self, action: #selector(tapbackAction))
        backView.addGestureRecognizer(tapBackGesture)
        
        self.addSubview(backView)
        
        
        tableView.frame = CGRect(x: 0, y: -tableHeight, width: frame.size.width, height: tableHeight)
        
        tableView.register(UINib(nibName: "AssetCell", bundle: nil), forCellReuseIdentifier: "AssetCell")
        
        tableView.delegate    = self
        tableView.dataSource  = self
        tableView.rowHeight   = 60
        
        self.addSubview(tableView)
        
        self.startAnimation()
        self.dataSource = list

    }
    
    func startAnimation() -> Void {
        
        UIView.animate(withDuration: 0.3) { 
            self.backView.alpha = 0.4
            self.tableView.frame = CGRect(x: 0, y: 64, width: self.tableView.frame.size.width, height: self.tableHeight)
        }
    }
    
    @objc func tapbackAction() -> Void {
        self.cancle()
     
    }
    
    func cancle() -> Void {
        self.delegate?.cancle()
        self.stopAnimation()
    }
    
    func stopAnimation() -> Void {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backView.alpha = 0
            self.tableView.frame = CGRect(x: 0, y: -self.tableHeight, width: self.tableView.frame.size.width, height: self.tableHeight)
        }) { (flag) in
            
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoAssetListView:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.cancle()
        let model = self.dataSource[indexPath.row]
        self.delegate?.selected(model: model)
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssetCell", for: indexPath) as! AssetCell
        
        let model = self.dataSource[indexPath.row]
        
        cell.model = model
        
        
        return cell
        
    }
}


