//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Soumya on 10/2/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class TweetsViewController: HamburgerChildViewController, UITableViewDelegate, UITableViewDataSource, NewTweetCreatedDelegate, TweetDetailDelegate, TweetCellDelegate, HamburgerChildViewControllerDelegate {
    var user: User!
    var tweetSourcer: TweetSourcer!
    var refreshControl: UIRefreshControl!
    var fetchOlderTweetsInProgress = false
    var currentTweetIndexPath: NSIndexPath!
    var currentTweet: Tweet!
    
    @IBOutlet weak var topBarUIView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar icons
        let centerTwitterImage = UIImage(named: "Twitter_logo_blue_32.png")
        self.navigationItem.titleView = UIImageView(image: centerTwitterImage)

        // set user
        user = User.currentUser
        tweetSourcer = TweetSourcer(user: user)
        
        // setup table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // load initial tweets
        getNewTweets()
        
        // pull to refresh controller
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "getNewTweets", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func getNewTweets() {
        tweetSourcer.loadRecentTweets { (error) -> () in
            if (error == nil) {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            } else {
                print("error getting home timeline: \(error!)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        self.performSegueWithIdentifier("newTweetSegue", sender: self)
    }
    
    // table view delegate methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = self.tweetSourcer.tweets![indexPath.row]
        cell.delegate = self
        
        // INFINITE SCROLL
        // check if we should load more older tweets
        if (!fetchOlderTweetsInProgress &&
            indexPath.row > self.tweetSourcer.tweets!.count - THRESHOLD_TO_FETCH_OLDER_TWEETS) {
                fetchOlderTweetsInProgress = true
                tweetSourcer.loadOlderTweets({ (error) -> () in
                    if (error == nil) {
                        self.tableView.reloadData()
                    } else {
                        print("Error loading older tweets")
                    }
                    self.fetchOlderTweetsInProgress = false
                })
        }
        
        return cell        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweetSourcer.tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentTweetIndexPath = indexPath
        self.currentTweet = tweetSourcer.tweets![currentTweetIndexPath.row]
        self.performSegueWithIdentifier("tweetDetailSegue", sender: self)
    }
    
    // New Tweet Delegate
    func newTweetCreated(tweet: Tweet?, error: NSError?) {
        if (tweet != nil) {
            tweetSourcer.addTweetAtTheBeginning(tweet!)
            self.tableView.reloadData()
        } else {
            print("Error creating tweet")
        }
    }
    
    // Tweet detail view delegate
    func didReturnFromTweetDetail(currentTweetIndexPath: NSIndexPath) {
        tableView.reloadRowsAtIndexPaths([currentTweetIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    // Tweet Cell Profile Image tapped delegate
    func tweetCellProfileImageTapped(tweetCell: TweetCell) {
        self.currentTweet = tweetCell.tweet
        self.performSegueWithIdentifier("profileViewSegue", sender: self)
    }
    
    // delegate for view that we open when cell profile image is tapped
    func hamburgerChildViewControllerWantsToClose(childViewController: HamburgerChildViewController) {
        childViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)

        if (segue.identifier == "newTweetSegue") {
            let navigationController = segue.destinationViewController as! UINavigationController
            let newTweetViewController = navigationController.viewControllers[0] as! NewTweetViewController
            newTweetViewController.delegate = self
        } else if (segue.identifier == "tweetDetailSegue") {
            let navigationController = segue.destinationViewController as! UINavigationController
            let tweetDetailViewController = navigationController.viewControllers[0] as! TweetDetailViewController
            tweetDetailViewController.tweet = currentTweet
            tweetDetailViewController.currentTweetIndexPath = currentTweetIndexPath
            tweetDetailViewController.delegate = self
        } else if (segue.identifier == "profileViewSegue") {
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.userScreenNameToShowProfile = currentTweet.author?.screenName
            profileViewController.hamburgerChildViewDelegate = self
        }
    }
}
