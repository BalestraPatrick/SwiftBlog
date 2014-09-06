//
//  ViewController.swift
//  SwiftBlog
//
//  Created by Patrick Balestra on 04/09/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

import UIKit

class BlogPost {
    var title = String()
    var link = String()
    var description = String()
    var date = String()
}

class TableViewController: UITableViewController, NSXMLParserDelegate {
                            
    var parser = NSXMLParser()
    var blogPosts: [BlogPost] = []
    
    var eName = String()
    var postTitle = String()
    var postLink = String()
    var descriptionText = String()
    var postDate = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.frame = CGRectMake(0, 0, 320, 568)
        
        navigationController.navigationBar.tintColor = UIColor.whiteColor()
        navigationController.navigationBar.setBackgroundImage(UIImage(named: "NavigationBarBackground"), forBarMetrics: .Default)
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(), NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 18)]
        navigationController.navigationBar.shadowImage = UIImage()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        var url: NSURL = NSURL.URLWithString("https://developer.apple.com/swift/blog/news.rss")
        parser = NSXMLParser(contentsOfURL: url)
        parser.delegate = self
        parser.parse()

        let contents = NSString(contentsOfURL: url, encoding: 0, error: nil)
        
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        eName = elementName
        if elementName == "item" {
            postTitle = String()
            postLink = String()
            descriptionText = String()
            postDate = String()
        }
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        if elementName == "item" {
            let blogPost: BlogPost = BlogPost()
            blogPost.title = postTitle
            blogPost.link = postLink
            blogPost.description = descriptionText
            blogPost.date = postDate
            blogPosts.append(blogPost)
        }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if (!data.isEmpty) {
            if eName == "title" {
                postTitle += data
            } else if eName == "link" {
                postLink += data
            } else if eName == "description" {
                descriptionText += data
            } else if eName == "pubDate" {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "EEE, dd LLL yyyy HH:mm:ss zzz"
                dateFormatter.timeZone = NSTimeZone(abbreviation: "PDT")
                let formattedDate = dateFormatter.dateFromString(data)
                if formattedDate != nil {
                    dateFormatter.dateStyle = .MediumStyle;
                    dateFormatter.timeStyle = .NoStyle;
                    postDate = dateFormatter.stringFromDate(formattedDate!)
                }
            }
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return blogPosts.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        let currentBlogPost: BlogPost = blogPosts[indexPath.row]
        cell.textLabel.text = currentBlogPost.title
        cell.detailTextLabel.text = currentBlogPost.description
        cell.textLabel.numberOfLines = 0
        cell.detailTextLabel.numberOfLines = 1
        
        let dateLabel = UILabel(frame: CGRectMake(0, 0, 80, 25))
        dateLabel.textColor = UIColor.orangeColor()
        dateLabel.textAlignment = .Right;
        dateLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        dateLabel.text = currentBlogPost.date
        cell.accessoryView = dateLabel
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "post") {
            let webView: WebviewPost = segue!.destinationViewController as WebviewPost
            webView.blogPostURL = NSURL(string:blogPosts[tableView.indexPathForSelectedRow().row].link)
        }
    }

}
