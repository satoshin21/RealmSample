//
//  Entry.swift
//  RealmSample
//
//  Created by Satoshi Nagasaka on 2015/05/13.
//  Copyright (c) 2015年 SatoshiN21. All rights reserved.
//

import UIKit
import ObjectMapper
import Realm

class Entry : RLMObject {
    
    dynamic var content : String = ""
    dynamic var link : String = ""
    dynamic var publishedDate : NSDate = NSDate()
    dynamic var title : String = ""
    dynamic var contentSnippet : String = ""
//    dynamic var categories : [String] = []
    
    required convenience init?(_ map: Map) {
        self.init()
        mapping(map)
    }
    
    override class func primaryKey() -> String {
        return "link"
    }
}

extension Entry : Mappable {
    
    func mapping(map: Map) {
        content         <- map["content"]
        link            <- map["link"]
        publishedDate   <- (map["publishedDate"] , EntryDateTransform())
        title           <- map["title"]
        contentSnippet  <- map["contentSnippet"]
//        categories      <- map["categories"]
    }
}


class EntryDateTransform : DateTransform {
    override func transformFromJSON(value: AnyObject?) -> NSDate? {
        if let dateStr = value as? String {
            return NSDate.dateWithString(
                dateStr,
                format: "E, dd MMM yyyy HH:mm:ss zzzz" ,
                locale : NSLocale(localeIdentifier: "en_US"))
        }
        return nil
    }
}
