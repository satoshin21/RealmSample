//
//  NSDate+Formatter.swift
//  RealmSample
//
//  Created by Satoshi Nagasaka on 2015/05/13.
//  Copyright (c) 2015年 SatoshiN21. All rights reserved.
//

import Foundation

extension Date {
    public static func dateWithString(_ dateStr : String? , format : String, locale : Locale) ->Date? {
        if let uwDateStr = dateStr {
            let df : DateFormatter = DateFormatter()
            df.locale = Locale(identifier: "en_US")
            df.timeZone = TimeZone.current
            df.dateFormat = format
            return df.date(from: uwDateStr)
        }
        
        return nil
    }
}
