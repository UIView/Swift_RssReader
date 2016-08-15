//
//  ReaderDetailViewController.swift
//  RssReader
//
//  Created by Yahui Duan on 16/8/15.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

import UIKit
import WebKit

class ReaderDetailViewController: UIViewController,WKNavigationDelegate {
    var tempItem : MWFeedItem?
    let tempWebView = WKWebView()
    var progBar = UIProgressView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tempWebView.frame = self.view.frame
        let tempRequest = NSMutableURLRequest.init(URL: NSURL.init(string: "https://www.baidu.com")!)
        tempRequest.timeoutInterval = 15.0
        tempWebView.loadRequest(tempRequest)
        tempWebView.navigationDelegate = self
        self.view.addSubview(tempWebView)
        
        
        progBar = UIProgressView(frame: CGRectMake(0, 64, self.view.frame.width, 30))
        progBar.progress = 0.0
        progBar.alpha = 0.0
        progBar.tintColor = UIColor.grayColor()
        tempWebView.addSubview(progBar)

        tempWebView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.New, context: nil)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tempWebView.removeObserver(self, forKeyPath: "estimatedProgress")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Progress animate
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" {
            self.progBar.alpha = 1.0
            progBar.setProgress(Float(tempWebView.estimatedProgress), animated: true)
            //进度条的值最大为1.0
            if(tempWebView.estimatedProgress >= 1.0) {
                UIView.animateWithDuration(0.3, delay: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.progBar.alpha = 0.0
                    }, completion: { (finished:Bool) -> Void in
                        self.progBar.progress = 0
                })
            }
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    // MARK: - WKWebView Delegate
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(" webview load start")

    }
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        NSLog("didCommitNavigation ")
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print(" webview load finish")
    }

    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        NSLog("didFailNavigation %@ ", error)
    }
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError){
        NSLog("didFailProvisional %@ ", error)
    }
    
}
