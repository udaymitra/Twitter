//
//  User.swift
//  Twitter
//
//  Created by Soumya on 10/1/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

var _currentUser: User?
let CURRENT_USER_KEY = "CURRENT_USER_KEY"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

// TODO - User class to implement NSCoding
// TODO - make class vars private with getters
class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
 
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
    }
    
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: completion)
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        TwitterClient.sharedInstance.loginWithCompletion(completion)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                // read last logged in user from NSUserDefaults
                let data = NSUserDefaults.standardUserDefaults().objectForKey(CURRENT_USER_KEY) as? NSData
                if data != nil {
                    do {
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        _currentUser = User(dictionary: dictionary)
                    } catch {
                        // TODO: show popup
                        print("Error while deserialising current user")
                    }
                }
            }
            return _currentUser
        }

        set(user) {
            _currentUser = user
            
            if (_currentUser != nil) {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject((_currentUser?.dictionary)!, options: NSJSONWritingOptions())
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: CURRENT_USER_KEY)
                } catch {
                    // TODO: show popup
                    print("Error while serialising current user")
                }
            } else {
                // clear NSUserDefaults for the user key
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: CURRENT_USER_KEY)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

}
