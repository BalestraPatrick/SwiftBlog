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
    
    var blogPostURL: URL? = nil
    
    override func viewDidLoad() {
        let request = URLRequest(url: blogPostURL!)
        webView.loadRequest(request)
        webView.sizeToFit()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    @IBAction func openInSafari(sender: AnyObject) {
        UIApplication.shared.open(blogPostURL!, options: [:], completionHandler: nil)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
