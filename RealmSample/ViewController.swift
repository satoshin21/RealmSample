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
import RealmSwift

class ViewController: UITableViewController {
    
    let hotEntryUrl = "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://b.hatena.ne.jp/hotentry/it.rss&num=100"
    
    var entries : [(Entry)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .None
        
        guard let realm = try? Realm() else {
            // FIXME: you need to handle errors.
            return
        }
        
        self.updateTableView()
        
        Alamofire.request(.GET, hotEntryUrl).responseJSON { (request, response, result) -> Void in
            if result.isFailure {
                return
            }
            
            let json = JSON(result.value!)
            response?.statusCode
            let entries = json["responseData"]["feed"]["entries"]
            realm.beginWrite()
            for (_, subJson) : (String, JSON) in entries {
                let entry : Entry = Mapper<Entry>().map(subJson.dictionaryObject)!
                realm.add(entry, update: true)
            }
            
            do {
                try realm.commitWrite()
            } catch {
                
            }
            self.updateTableView()
        }
        
    }
    
    func updateTableView() {

        do {
            self.entries = try Realm().objects(Entry).sort({ (entry1, entry2) -> Bool in
            let res = entry1.publishedDate.compare(entry2.publishedDate)
            return (res == .OrderedAscending || res == .OrderedSame)
            })
        }catch {}
        
        tableView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let entries = entries {
            return entries.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as! EntryTableViewCell
        
        // if entries have been nil,"cellForRowAtIndexPath:indexPath:" isn't called.
        let entry = entries![indexPath.row]
        
        // date format.
        let df = NSDateFormatter()
        df.locale = NSLocale(localeIdentifier: "ja_JP")
        df.timeZone = NSTimeZone.systemTimeZone()
        df.dateFormat = "MM/dd"
        let dateStr = df.stringFromDate(entry.publishedDate)
        
        cell.titleLabel.text = [dateStr,entry.title].joinWithSeparator(" ")
        cell.descriptionLabel.text = entry.contentSnippet
        
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let entry = entries![indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: entry.link)!)
    }
}

