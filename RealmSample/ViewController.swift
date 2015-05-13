//
//  ViewController.swift
//  RealmSample
//
//  Created by Satoshi Nagasaka on 2015/05/13.
//  Copyright (c) 2015年 SatoshiN21. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import SwiftyJSON
import Realm

class ViewController: UITableViewController {
    
    let hotEntryUrl = "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://b.hatena.ne.jp/hotentry/it.rss&num=100"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(.GET, hotEntryUrl, parameters: nil).responseJSON(options: NSJSONReadingOptions.AllowFragments) { (request, response, responseObject, error) -> Void in
            let json = JSON(responseObject!)
            
            let entries = json["responseData"]["feed"]["entries"]
            for (index: String, subJson : JSON) in entries {
                let entry : Entry? = Mapper<Entry>().map(subJson.dictionaryObject)
                println(entry?.publishedDate)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

