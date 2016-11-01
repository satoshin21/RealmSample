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
import RealmSwift

class ViewController: UITableViewController {
    
    let hotEntryUrl = "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://b.hatena.ne.jp/hotentry/it.rss&num=100"
    
    var entries : [(Entry)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        
        guard let realm = try? Realm() else {
            // FIXME: you need to handle errors.
            return
        }
        
        self.updateTableView()
        
        // get Hatena hotentries
        Alamofire.request(.GET, hotEntryUrl).responseJSON { (request, response, result) -> Void in
            
            if result.isFailure {
                // FIXME:you need to handle errors.
                return
            }
            
            // write request result to realm database
            let json = JSON(result.value!)
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
    
    /**
     select entry data from realm db
     and update table view with selected data.
     */
    func updateTableView() {

        do {
            self.entries = try Realm().objects(Entry).sorted(by: { (entry1, entry2) -> Bool in
            let res = entry1.publishedDate.compare(entry2.publishedDate)
            return (res == .orderedAscending || res == .orderedSame)
            })
        }catch {}
        
        tableView.reloadData()
    }
    
    // MARK:- UITableView DataSource / Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let entries = entries {
            return entries.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier") as! EntryTableViewCell
        
        // if entries have been nil,"cellForRowAtIndexPath:indexPath:" isn't called.
        let entry = entries![indexPath.row]
        
        // date format.
        let df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        df.timeZone = TimeZone.current
        df.dateFormat = "MM/dd"
        let dateStr = df.string(from: entry.publishedDate as Date)
        
        cell.titleLabel.text = [dateStr,entry.title].joined(separator: " ")
        cell.descriptionLabel.text = entry.contentSnippet
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = entries![indexPath.row]
        if let link = URL(string: entry.link) {
            UIApplication.shared.openURL(link)
        }
    }
}

