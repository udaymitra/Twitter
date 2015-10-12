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
        getTweetsWithParams("1.1/statuses/home_timeline.json", parameters: parameters, completion: completion)
    }
    
    func getTweetsWithParams(uri: String, parameters: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET(uri, parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweets = Tweet.parseTweets(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(tweets: nil, error: error)
        })
    }
    
    func getParamsForScreenName(userScreenName: String) -> NSDictionary {
        var parameters = [String : AnyObject]()
        parameters["screen_name"] = userScreenName
        return parameters
    }
    
    func getUserTimeline(userScreenName: String, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        getTweetsWithParams("1.1/statuses/user_timeline.json", parameters: getParamsForScreenName(userScreenName), completion: completion)
    }

    func getFavorites(userScreenName: String, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        getTweetsWithParams("1.1/favorites/list.json", parameters: getParamsForScreenName(userScreenName), completion: completion)
    }
    
    func getMentions(parameters: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        getTweetsWithParams("1.1/statuses/mentions_timeline.json", parameters: parameters, completion: completion)
    }
    
    func getUserPlus(userScreenName: String, completion: (userPlus: UserPlus?, error: NSError?) ->()) {
        GET("/1.1/users/show.json", parameters: getParamsForScreenName(userScreenName),
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let userPlus = UserPlus(dictionary: response as! NSDictionary)
                completion(userPlus: userPlus, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(userPlus: nil, error: error)
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
    
    func unFavoriteTweet(tweetId: String!, completion: (error: NSError?) -> ()) {
        let parameters = ["id" : tweetId]
        POST("/1.1/favorites/destroy.json", parameters: parameters, constructingBodyWithBlock: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
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
    
    func unRetweet(tweet: Tweet, completion: (error: NSError?) -> ()) {
        let retweetedStatus = tweet.dictionary["retweeted_status"] as? NSDictionary
        let originalTweetId = (retweetedStatus == nil)
                                ? tweet.idString!
                                : retweetedStatus!["id_str"] as! String
        var parameters = [String : AnyObject]()
        parameters["include_my_retweet"] = 1
        GET("/1.1/statuses/show.json?id=\(originalTweetId)", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let responseDict = response as! NSDictionary
            let currentUserRetweet = responseDict["current_user_retweet"] as! NSDictionary
            let myTweetId = currentUserRetweet["id_str"] as! String
            self.destroyTweet(myTweetId, completion: completion)
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            completion(error: error)
        }
    }
    
    func destroyTweet(idString: String, completion: (error: NSError?) -> ()) {
        POST("/1.1/statuses/destroy/\(idString).json", parameters: nil, constructingBodyWithBlock: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(error: nil)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            completion(error: error)
        })
    }
    
}
