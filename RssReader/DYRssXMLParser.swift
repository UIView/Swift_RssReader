//
//  DYRssXMLParser.swift
//  RssReader
//
//  Created by Yahui Duan on 16/8/15.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

import UIKit

public enum DYRssXMLParserType : Int {
    
    case Unknown
    case RssType_0_9 // parser rss 0.9x
    case RssType_1_0 // parser rss 1.0x
    case RssType_2_0 // parser rss 2.0x
    case RssTypeAtom // parser Atom

}

class DYRssXMLParser: NSObject {
    let timeoutInterval = 45.0
    var parserURLSession : NSURLSession?
    
// MARK: - Parser Request
    func startParserRssRequest(rssSource : NSString) -> NSArray {
        
        parserURLSession = NSURLSession.sharedSession()
        let feedURL = NSURL.init(string: rssSource as String)
        let tempRequest = NSURLRequest.init(URL: feedURL!, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: timeoutInterval)
      let dataTask = parserURLSession!.dataTaskWithRequest(tempRequest, completionHandler: { (data, response, error) in
        guard data != nil else{
            print(" Data is nil @ \n", error )
            return
        }
            let tempString = NSString.init(data: data!, encoding: NSUTF8StringEncoding)
            print(tempString)
        
        })
       dataTask.resume()
        
        return []
    }
    
    
}
