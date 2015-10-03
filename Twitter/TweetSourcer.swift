//
//  TweetSourcer.swift
//  Twitter
//
//  Created by Soumya on 10/3/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class TweetSourcer: NSObject {
    let TWEET_FETCH_BATCH_SIZE = 20
    
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
        
        print("parameters: \(parameters)")
        
        user?.homeTimelineWithParams(parameters, completion: { (var newTweets, error) -> () in
            if (newTweets != nil) {
                if (self.tweets == nil) {
                    self.tweets = newTweets
                } else {
                    newTweets!.appendContentsOf(self.tweets!)
                    self.tweets = newTweets
                }
            }
            completion(error: error)
        })
    }
}
