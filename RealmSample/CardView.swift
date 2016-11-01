//
//  CardView.swift
//  RealmSample
//
//  Created by Satoshi Nagasaka on 2015/05/14.
//  Copyright (c) 2015年 SatoshiN21. All rights reserved.
//

import UIKit

class CardView: UIView {

    var select = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateShadow()
        self.layoutIfNeeded()
    }
    
    func updateShadow(){
        self.clipsToBounds = false
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath;
        self.layer.shouldRasterize = false;
        self.layer.rasterizationScale = UIScreen.main.scale;
        
        self.layer.shadowColor = select ? UIColor.gray.cgColor : UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.5
    }
}
