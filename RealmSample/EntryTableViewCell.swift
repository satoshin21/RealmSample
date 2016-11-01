//
//  EntryTableViewCell.swift
//  RealmSample
//
//  Created by Satoshi Nagasaka on 2015/05/14.
//  Copyright (c) 2015年 SatoshiN21. All rights reserved.
//

import UIKit

class EntryTableViewCell : UITableViewCell {

    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        cardView.clipsToBounds = false
        
        self.clipsToBounds = false
        self.contentView.clipsToBounds = false
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        self.highlight(highlighted)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        self.highlight(selected)
    }
    
    func highlight(_ highLight : Bool){
        cardView.select = highLight
        cardView.setNeedsLayout()
    }
}
