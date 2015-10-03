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
    private(set) var favoriteCount: Int?
    private(set) var retweetCount: Int?
    private(set) var idString: String?
    
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
        
        favoriteCount = dictionary["favorite_count"] as? Int
        retweetCount = dictionary["retweet_count"] as? Int
        idString = dictionary["id_str"] as? String
    }
    
    class func parseTweets(array: [NSDictionary]) -> [Tweet] {
        var tweetArray = [Tweet]()
        for dict in array {
            tweetArray.append(Tweet(dictionary: dict))
        }
        return tweetArray
    }
    
    func formatTimeElapsed() -> String {
        let formatter = NSDateComponentsFormatter()
        formatter.unitsStyle = NSDateComponentsFormatterUnitsStyle.Abbreviated
        formatter.collapsesLargestUnit = true
        formatter.maximumUnitCount = 1
        let interval = NSDate().timeIntervalSinceDate(self.createdAt!)
        return formatter.stringFromTimeInterval(interval)!
    }
}
