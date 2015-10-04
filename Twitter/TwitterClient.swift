//
//  TwitterClient.swift
//  Twitter
//
//  Created by Soumya on 9/29/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

let twitterConsumerKey = "YDjjLxXs7KkJddfiNohjcN9ht"
let twitterConsumerSecret = "1vcFEUJwR0m4YPKozoCvUH3E9TEZ5tiPGR8RGEpHAspmoEBGcL"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    private var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimelineWithParams(parameters: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweets = Tweet.parseTweets(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            completion(tweets: nil, error: error)
        })        
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token and redirect to authorization page
        requestSerializer.removeAccessToken()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterDemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(authURL)
        }) { (error: NSError!) -> Void in
            loginCompletion?(user: nil, error: error)
        }
    }
    
    func postTweet(parameters: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("/1.1/statuses/update.json", parameters: parameters, constructingBodyWithBlock: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(tweet: nil, error: error)
        }
    }
    
    func retweet(tweetId: String!, completion: (error: NSError?) -> ()) {
        let parameters = ["id" : tweetId]
        POST("/1.1/statuses/retweet/\(tweetId).json", parameters: parameters, constructingBodyWithBlock: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(error: nil)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            completion(error: error)
        }
    }
    
    func favoriteTweet(tweetId: String!, completion: (error: NSError?) -> ()) {
        let parameters = ["id" : tweetId]
        POST("/1.1/favorites/create.json", parameters: parameters, constructingBodyWithBlock: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(error: nil)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            completion(error: error)
        }
    }
    
    func openUrl(url: NSURL) {        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            self.requestSerializer.saveAccessToken(accessToken)
            self.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                loginCompletion?(user: nil, error: error)
            })
        }) { (error: NSError!) -> Void in
            loginCompletion?(user: nil, error: error)
        }
    }
    
}
