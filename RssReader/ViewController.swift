//
//  ViewController.swift
//  RssReader
//
//  Created by Yahui Duan on 16/8/11.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController,MWFeedParserDelegate {
   private var feedParser : MWFeedParser = MWFeedParser.init(feedURL: NSURL.init(string: "http://techcrunch.com/feed/"))
    var itemsToDisplay : NSArray = NSArray()
   private var parsedItems : NSMutableArray = NSMutableArray()
   private var formatter : NSDateFormatter = NSDateFormatter()
   private let CellIdentifier = "NewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Rss Reader"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(ViewController.refreshAction))
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        feedParser.delegate = self
        feedParser.feedParseType = ParseType.init(0)
        feedParser.connectionType = ConnectionType.init(0)
        feedParser.parse()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action

    func refreshAction() {
        // test right button
        parsedItems.removeAllObjects()
        feedParser.stopped
        feedParser.parse()
        self.tableView.userInteractionEnabled = false
        self.tableView.alpha = 0.3
    }
    func updateTableWithParsedItems() {
        self.itemsToDisplay = parsedItems.sortedArrayUsingDescriptors(NSArray.init(object: NSSortDescriptor.init(key: "date", ascending: false)) as! [NSSortDescriptor])
        self.tableView.userInteractionEnabled = true
        self.tableView.alpha = 1
        self.tableView.reloadData()
    }
    // MARK: - MWFeedParserDelegate
    func feedParserDidStart(parser: MWFeedParser!) {
        
        print(parser)
        
    }
    func feedParser(parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        if item != nil {
            parsedItems.addObject(item)
        }
    }
    
    func feedParser(parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        print(info.title)
    }
    
    func feedParserDidFinish(parser: MWFeedParser!) {
        self.updateTableWithParsedItems()
    }
    
    func feedParser(parser: MWFeedParser!, didFailWithError error: NSError!) {
        print(error)
    }
//    MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToDisplay.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: CellIdentifier)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        let nItem = itemsToDisplay[indexPath.row]
        cell?.textLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        cell?.textLabel?.text = nItem.title
        cell?.detailTextLabel?.text = nItem.summary
        return cell!
    }
// MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

