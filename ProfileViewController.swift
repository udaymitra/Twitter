//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Soumya on 10/8/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class ProfileViewController: HamburgerChildViewController, UITableViewDelegate, UITableViewDataSource {
    var userTweets: [Tweet]?
    var favorites: [Tweet]?
    var userPlus: UserPlus?
    var tweetsToShow: [Tweet]? {
        didSet {
            tweetsTableView.reloadData()
        }
    }

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var friendsCountLabel: UILabel!
    
    @IBOutlet weak var tweetsFavsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tweetsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.asyncCalls()
        
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        tweetsTableView.estimatedRowHeight = 100
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        
        self.tweetsFavsSegmentedControl.selectedSegmentIndex = 0
        setTweetsToShow()
    }
    
    func asyncCalls() {
        let currentUserScreenName = User.currentUser!.screenName!
        TwitterClient.sharedInstance.getUserPlus(currentUserScreenName) { (userPlus, error) -> () in
            if (error == nil) {
                self.userPlus = userPlus
            } else {
                print("Error getting UserPlus")
            }
            self.populateView()
        }
        TwitterClient.sharedInstance.getUserTimeline(currentUserScreenName) { (tweets, error) -> () in
            if (error == nil) {
                self.userTweets = tweets
            } else {
                print("Error getting user timeline")
            }
            self.populateView()
        }
        TwitterClient.sharedInstance.getFavorites(currentUserScreenName) { (tweets, error) -> () in
            if (error == nil) {
                self.favorites = tweets
            } else {
                print("Error getting favorites")
            }
            self.populateView()
        }
    }
    
    func populateView() {
        if let userPlusObject = userPlus {
            bannerImageView.setImageWithURL(userPlusObject.profileBannerImageUrl)
            profileImageView.setImageWithURL(userPlusObject.user.profileImageUrl)
            userNameLabel.text = userPlusObject.user.name
            screenNameLabel.text = "@\(userPlusObject.user.screenName!)"
            descriptionLabel.text = userPlusObject.user.tagline
            followersCountLabel.text = "\(userPlusObject.user.followersCount!)"
            friendsCountLabel.text = "\(userPlusObject.user.friendsCount!)"
            
            tweetsFavsSegmentedControl.setTitle("Tweets \(userPlusObject.tweetsCount!)", forSegmentAtIndex: 0)
            tweetsFavsSegmentedControl.setTitle("Favorites \(userPlusObject.favoritesCount!)", forSegmentAtIndex: 1)
        }
        
        if (self.favorites != nil || self.userTweets != nil) {
            setTweetsToShow()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweetsToShow?[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetsToShow?.count ?? 0
        
    }
    
    func setTweetsToShow() {
        tweetsToShow = tweetsFavsSegmentedControl.selectedSegmentIndex == 0
            ? userTweets
            : favorites
    }

    @IBAction func tweetsFavsControllerChanged(sender: AnyObject) {
        setTweetsToShow()
    }
}
