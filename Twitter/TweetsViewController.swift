//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Soumya on 10/2/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user: User!
    var tweetSourcer: TweetSourcer!
    var refreshControl: UIRefreshControl!
    
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
        print("Write a new tweet")
    }
    
    // table view delegate methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = self.tweetSourcer.tweets![indexPath.row]
        return cell        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweetSourcer.tweets?.count ?? 0
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
