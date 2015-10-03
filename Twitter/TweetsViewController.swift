//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Soumya on 10/2/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    var user: User?
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = User.currentUser
        
        user?.homeTimelineWithParams(nil) { (tweets, error) -> () in
            if (tweets != nil) {
                self.tweets = tweets
                // reload table
                for tweet in self.tweets! {
                    print("tweet: \(tweet.text!), created: \(tweet.createdAt)")
                }
            } else {
                print("error getting home timeline: \(error!)")
            }
        }
        
        
        // tweet.favorite will do a POST

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutTap(sender: AnyObject) {
        User.currentUser?.logout()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
