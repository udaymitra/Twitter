//
//  TweetSourcer.swift
//  Twitter
//
//  Created by Soumya on 10/3/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

let TWEET_FETCH_BATCH_SIZE = 20
let THRESHOLD_TO_FETCH_OLDER_TWEETS = 5

class TweetSourcer: NSObject {
    
    private(set) var user: User?
    private(set) var tweets: [Tweet]?
    
    init(user: User?) {
        self.user = user
    }
    
    func loadRecentTweets(completion: (error: NSError?) -> ()) {
        var parameters = [String : AnyObject]()
        parameters["count"] = TWEET_FETCH_BATCH_SIZE
        
        if (tweets != nil) {
            parameters["since_id"] = tweets?.first?.idString!
        }
        
        user?.homeTimelineWithParams(parameters, completion: { (var newTweets, error) -> () in
            if (newTweets != nil) {
                if (self.tweets == nil) {
                    self.tweets = newTweets
                } else {
                    newTweets!.appendContentsOf(self.tweets!)
                    let maxTweets = min(self.tweets!.count, TWEET_FETCH_BATCH_SIZE)
                    newTweets = Array(newTweets![0..<maxTweets])
                    self.tweets = newTweets
                }
            }
            completion(error: error)
        })
    }
    
    func addTweetAtTheBeginning(tweet: Tweet) {
        if (tweets != nil) {
            tweets!.insert(tweet, atIndex: 0)
        } else {
            tweets = [Tweet]()
            tweets!.append(tweet)
        }
    }
    
    func loadOlderTweets(completion: (error: NSError?) -> ()) {
        var parameters = [String : AnyObject]()
        parameters["count"] = TWEET_FETCH_BATCH_SIZE
        let lastTweetId = tweets?.last?.idString!
        parameters["max_id"] = lastTweetId
        user?.homeTimelineWithParams(parameters, completion: { (newTweets, error) -> () in
            if (newTweets != nil) {
                for tweet in newTweets! {
                    if (tweet.idString! != lastTweetId ) {
                        self.tweets!.append(tweet)
                    }
                }
            }
            completion(error: error)
        })
    }
}
