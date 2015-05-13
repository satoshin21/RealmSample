//
//  Entry.swift
//  RealmSample
//
//  Created by Satoshi Nagasaka on 2015/05/13.
//  Copyright (c) 2015年 SatoshiN21. All rights reserved.
//

import UIKit
import ObjectMapper

class Entry : Mappable {
    
    var content : String?
    var link : String?
    var publishedDate : NSDate?
    var title : String?
    var categories : [String]?
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        content         <- map["content"]
        link            <- map["link"]
        publishedDate   <- (map["publishedDate"] , EntryDateTransform())
        title           <- map["title"]
        categories      <- map["categories"]
    }
}

class EntryDateTransform : DateTransform {
    override func transformFromJSON(value: AnyObject?) -> NSDate? {
        if let dateStr = value as? String {
            return NSDate()
        }
        return nil
    }
}
