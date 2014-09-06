//
//  WebviewPost.swift
//  SwiftBlog
//
//  Created by Patrick Balestra on 04/09/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

import UIKit

class WebviewPost: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var blogPostURL: NSURL = NSURL()
    
    override func viewDidLoad() {
        let request = NSURLRequest(URL: blogPostURL)
        webView.loadRequest(request)
        webView.sizeToFit()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
    }
    
    @IBAction func openInSafari(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(blogPostURL)
    }
    
    func webViewDidFinishLoad(webView: UIWebView!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
    }
}
