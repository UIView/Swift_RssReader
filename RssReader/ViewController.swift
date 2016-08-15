//
//  ViewController.swift
//  RssReader
//
//  Created by Yahui Duan on 16/8/11.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController,MWFeedParserDelegate {
   private var feedParser : MWFeedParser = MWFeedParser.init(feedURL: NSURL.init(string: "http://blog.csdn.net/nslong/rss/list"))
    var itemsToDisplay : NSArray = NSArray()
   private var parsedItems : NSMutableArray = NSMutableArray()
   private var formatter : NSDateFormatter = NSDateFormatter()
   private let CellIdentifier = "ArticleListTableViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Rss Reader"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(ViewController.addRssResourceDataAction))
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        let tempRefresh = UIRefreshControl()
        tempRefresh.addTarget(self, action: #selector(ViewController.refreshTableDataAction), forControlEvents: UIControlEvents.ValueChanged)
        tempRefresh.attributedTitle = NSAttributedString.init(string: "Y(^_^)Y 加载中……")
        tempRefresh.tintColor = UIColor.grayColor()
        self.refreshControl = tempRefresh
        
        feedParser.delegate = self
        feedParser.feedParseType = ParseType.init(0)
        feedParser.connectionType = ConnectionType.init(0)
        feedParser.parse()
        
        let parser = DYRssXMLParser()
        parser.startParserRssRequest("http://blog.csdn.net/hyp520520/rss/list")
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action
    func addRssResourceDataAction() {
        
    }
    func refreshTableDataAction() {
        // test right button
        parsedItems.removeAllObjects()
        feedParser.stopped
        feedParser.parse()
        self.tableView.userInteractionEnabled = false
        self.tableView.alpha = 0.75
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
        self.refreshControl?.endRefreshing()

    }
    
    func feedParser(parser: MWFeedParser!, didFailWithError error: NSError!) {
        print(error)
        self.refreshControl?.endRefreshing()
    }
//    MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToDisplay.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! ArticleListTableViewCell
        let nItem = itemsToDisplay[indexPath.row] as! MWFeedItem
        cell.setArticleData(nItem)
        return cell
    }
    
// MARK: - Table view delegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let tempVC = segue.destinationViewController;
        
        if tempVC.isKindOfClass(ReaderDetailViewController) {
            let tempReaderVC = tempVC as!ReaderDetailViewController
            let tempCell = sender as!ArticleListTableViewCell
            let tempIndex = self.tableView.indexPathForCell(tempCell)
            let nItem = itemsToDisplay[tempIndex!.row] as! MWFeedItem
            tempReaderVC.tempItem = nItem
            
        }
        
    }
}

