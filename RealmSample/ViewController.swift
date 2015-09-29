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
    
    var entryArray : RLMResults?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .None
        
        let realm = RLMRealm.defaultRealm()
        self.updateTableView()
        
        
        Alamofire.request(.GET, hotEntryUrl).responseJSON { (request, response, result) -> Void in
            if result.isFailure {
                return
            }
            
            let json = JSON(result.value!)
            response?.statusCode
            let entries = json["responseData"]["feed"]["entries"]
            realm.beginWriteTransaction()
            for (_, subJson) : (String, JSON) in entries {
                let entry : Entry = Mapper<Entry>().map(subJson.dictionaryObject)!
                realm.addOrUpdateObject(entry)
            }
            realm.commitWriteTransaction()
            self.updateTableView()
        }
        
    }
    
    func updateTableView() {
        entryArray = Entry.allObjects().sortedResultsUsingProperty("publishedDate", ascending: true)
        tableView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = Entry.allObjects().count
        return  Int(count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CellIdentifier"
        let cell : EntryTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? EntryTableViewCell
        
        let entry = Entry.allObjects().objectAtIndex(UInt(indexPath.row)) as? Entry
        
        let date : NSDate = entry!.publishedDate
        cell!.titleLabel!.text = entry!.title
        cell!.descriptionLabel!.text = entry!.contentSnippet
        
        return cell!
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let entry : Entry? = Entry.allObjects().objectAtIndex(UInt(indexPath.row)) as? Entry
        UIApplication.sharedApplication().openURL(NSURL(string: entry!.link)!)
    }
}

