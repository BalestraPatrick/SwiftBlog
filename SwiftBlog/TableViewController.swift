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

class TableViewController: UITableViewController, XMLParserDelegate {
                            
    var parser = XMLParser()
    var blogPosts: [BlogPost] = []
    
    var eName = String()
    var postTitle = String()
    var postLink = String()
    var descriptionText = String()
    var postDate = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "NavigationBarBackground"), for: .default)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font:UIFont(name: "HelveticaNeue-Light", size: 18)!]
        navigationController?.navigationBar.shadowImage = UIImage()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let url = URL(string: "https://developer.apple.com/swift/blog/news.rss")
//        var url: URL = URL.URLWithString("https://developer.apple.com/swift/blog/news.rss")!
        parser = XMLParser(contentsOf: url!)!
        parser.delegate = self
        parser.parse()

        //let contents = String.init(contentsOf: url!, encoding: String.Encoding(rawValue: 0))
//        let contents = String(contentsOf: url, encoding: 0, error: nil)
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        eName = elementName
        if elementName == "item" {
            postTitle = String()
            postLink = String()
            descriptionText = String()
            postDate = String()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let blogPost: BlogPost = BlogPost()
            blogPost.title = postTitle
            blogPost.link = postLink
            blogPost.description = descriptionText
            blogPost.date = postDate
            blogPosts.append(blogPost)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        //let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if (!data.isEmpty) {
            if eName == "title" {
                postTitle += data
            } else if eName == "link" {
                postLink += data
            } else if eName == "description" {
                descriptionText += data
            } else if eName == "pubDate" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE, dd LLL yyyy HH:mm:ss zzz"
                dateFormatter.timeZone = TimeZone(abbreviation: "PDT")
                let formattedDate = dateFormatter.date(from: data)
                if formattedDate != nil {
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .none
                    postDate = dateFormatter.string(from: formattedDate!)
                }
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        let currentBlogPost: BlogPost = blogPosts[indexPath.row]
        cell.textLabel?.text = currentBlogPost.title
        cell.detailTextLabel?.text = currentBlogPost.description
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 1
        
        let dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 25))
        dateLabel.textColor = UIColor.orange
        dateLabel.textAlignment = .right
        dateLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        dateLabel.text = currentBlogPost.date
        cell.accessoryView = dateLabel
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "post") {
            let webView: WebviewPost = segue.destination as! WebviewPost
            webView.blogPostURL = URL(string:blogPosts[(tableView.indexPathForSelectedRow?.row)!].link)
        }
    }

}
