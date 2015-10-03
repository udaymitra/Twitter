//
//  Tweet.swift
//  Twitter
//
//  Created by Soumya on 10/1/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    // static member variable for NSDataFormatter for efficiency
    private struct Static {
        private static var formatter: NSDateFormatter? = nil
    }
    
    private(set) var author: User?
    private(set) var text: String?
    private(set) var createdAtString: String?
    private(set) var createdAt: NSDate?
    
    init(dictionary: NSDictionary) {
        author = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        if (Tweet.Static.formatter == nil) {
            // initialize only once
            Tweet.Static.formatter = NSDateFormatter()
            Tweet.Static.formatter!.dateFormat = "EEE MM d HH:mm:ss Z y"
        }
        
        createdAt = Tweet.Static.formatter!.dateFromString(createdAtString!)
    }
    
    class func parseTweets(array: [NSDictionary]) -> [Tweet] {
        var tweetArray = [Tweet]()
        for dict in array {
            tweetArray.append(Tweet(dictionary: dict))
        }
        return tweetArray
    }
}
