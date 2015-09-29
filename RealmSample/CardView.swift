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
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).CGPath;
        self.layer.shouldRasterize = false;
        self.layer.rasterizationScale = UIScreen.mainScreen().scale;
        
        self.layer.shadowColor = select ? UIColor.grayColor().CGColor : UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(0, 0)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.5
    }
}
