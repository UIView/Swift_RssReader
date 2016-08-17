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
   private var tempWebView : WKWebView!
   private var progBar : UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webCofig = WKWebViewConfiguration()
        webCofig.preferences.javaScriptEnabled=true
        tempWebView = WKWebView.init(frame: self.view.frame, configuration: webCofig)

        guard tempItem != nil else{
            // 不符合条件不执行下面语法
            return;
        }
        let cssFilePath = NSBundle.mainBundle().pathForResource("css", ofType: "html")
        let jsFilePath = NSBundle.mainBundle().pathForResource("js", ofType: "html")

        var tempCSS : String? = nil
        do{
            let cssString = try NSString.init(contentsOfFile: cssFilePath!, encoding: NSUTF8StringEncoding)
            tempCSS=cssString as String
        }catch{
            print(error)
        }
        
        var jsSting : String?
        do {
            jsSting = try String.init(contentsOfFile: jsFilePath!)
        }
        catch{
                print(error)
        }
        

        if tempItem!.summary.characters.count > 1 {
            var hemlString = "<!DOCTYPE html><html lang=\"zh-CN\"><head><meta charset=\"utf-8\"><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"><meta name=\"viewport\" content=\"width=device-width initial-scale=1.0\">"
            hemlString = hemlString + tempCSS! + "</head><body><p class=\"title\">" + tempItem!.title + "</p>"
            hemlString = hemlString + "<div class=\"diver\"></div><p style=\"text-align:left;font-size:9pt;margin-left: 14px;margin-top: 10px;margin-bottom: 10px;color:#CCCCCC\"></p><div class=\"content\">" + tempItem!.summary + "</div>"
            hemlString = hemlString + jsSting! + "</body></html>"
            
            tempWebView.loadHTMLString(hemlString, baseURL: nil)
            
        }else if tempItem!.content.characters.count > 1 {
            
            tempWebView.loadHTMLString(tempItem!.content, baseURL: nil)
            
        }else{
            
            let detailLink = tempItem!.link
            let tempRequest = NSMutableURLRequest.init(URL: NSURL.init(string: detailLink)!)
            tempRequest.timeoutInterval = 15.0
            tempWebView.loadRequest(tempRequest)
            
        }
        
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
        tempWebView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
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
    func setViewControllerNavBackItem() {
        
        let backBarItem = UIBarButtonItem()
     //   backBarItem.customView = backBarItem.setCustomBackBarItem(<#T##image: UIImage##UIImage#>, title: "返回", style: <#T##UIBarButtonItem.BarCustomStyle#>)
        self.navigationItem.backBarButtonItem = backBarItem
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    // MARK: - WKWebView Delegate
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(" webview load start")
        print(webView.URL?.absoluteString)
    }
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        NSLog("didCommitNavigation ")
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print(" webview load finish")
        if webView.URL!.absoluteString == "about:blank" {
            webView.evaluateJavaScript("AddImgClickEvent()", completionHandler: nil) 
        }
    }

    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        NSLog("didFailNavigation %@ ", error)
    }
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError){
        NSLog("didFailProvisional %@ ", error)
    }
    
}
