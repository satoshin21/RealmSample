//
//  NSDate+Formatter.swift
//  RealmSample
//
//  Created by Satoshi Nagasaka on 2015/05/13.
//  Copyright (c) 2015年 SatoshiN21. All rights reserved.
//

import Foundation

extension NSDate {
    public static func dateWithString(dateStr : String? , format : String, locale : NSLocale) ->NSDate? {
        if let uwDateStr = dateStr {
            let df : NSDateFormatter = NSDateFormatter()
            df.locale = NSLocale(localeIdentifier: "en_US")
            df.timeZone = NSTimeZone.defaultTimeZone()
            df.dateFormat = format
            return df.dateFromString(uwDateStr)
        }
        
        return nil
    }
}