//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Soumya on 10/2/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewTweetCreatedDelegate {
    var user: User!
    var tweetSourcer: TweetSourcer!
    var refreshControl: UIRefreshControl!
    var fetchOlderTweetsInProgress = false;
    
    @IBOutlet weak var topBarUIView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar icons
        self.navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
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
    
    // New Tweet Delegate
    func newTweetCreated(tweet: Tweet?, error: NSError?) {
        if (tweet != nil) {
            tweetSourcer.addTweetAtTheBeginning(tweet!)
            self.tableView.reloadData()
        } else {
            print("Error creating tweet")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if (segue.identifier == "newTweetSegue") {
            let navigationController = segue.destinationViewController as! UINavigationController
            let newTweetViewController = navigationController.viewControllers[0] as! NewTweetViewController
            newTweetViewController.delegate = self
        }
    }    
}
