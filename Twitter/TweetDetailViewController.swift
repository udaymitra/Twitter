//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Soumya on 10/4/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

@objc protocol TweetDetailDelegate {
    optional func didReturnFromTweetDetail(currentTweetIndexPath: NSIndexPath)
}

class TweetDetailViewController: UIViewController {
    @IBOutlet weak private var profileImageView: UIImageView!
    @IBOutlet weak private var userNameLabel: UILabel!
    @IBOutlet weak private var screenNameLabel: UILabel!
    @IBOutlet weak private var tweetText: UILabel!
    @IBOutlet weak private var numRetweetsLabel: UILabel!
    @IBOutlet weak private var numFavoritesLabel: UILabel!
    
    @IBOutlet weak private var replyImageView: UIImageView!
    @IBOutlet weak private var retweetImageView: UIImageView!
    @IBOutlet weak private var favoriteImageView: UIImageView!
    
    var tweet: Tweet!
    var currentTweetIndexPath: NSIndexPath!
    weak var delegate: TweetDetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.setImageWithURL(tweet.author!.profileImageUrl)
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        
        userNameLabel.text = tweet.author!.name
        screenNameLabel.text = "@\(tweet.author!.screenName!)"
        tweetText.text = tweet.text

        loadDynamicUiElements()

        replyImageView.userInteractionEnabled = true
        
        retweetImageView.userInteractionEnabled = true
        retweetImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("onRetweetTap:")))
        
        favoriteImageView.userInteractionEnabled = true
        favoriteImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("onFavoriteTap:")))
    }
    
    private func loadDynamicUiElements() {
        showRetweetIcon()
        showFavoriteIcon()
        numRetweetsLabel.text = "\(tweet.retweetCount!)"
        numFavoritesLabel.text = "\(tweet.favoriteCount!)"
    }
    
    private func showRetweetIcon() {
        let imageToShow = (tweet!.didUserRetweet) ? "retweet_on" : "retweet"
        self.retweetImageView.image = UIImage(named: imageToShow)
    }
    
    private func showFavoriteIcon() {
        let imageToShow = (tweet!.didUserFavorite) ? "favorite_on" : "favorite"
        self.favoriteImageView.image = UIImage(named: imageToShow)
    }
    
    // actions
    @IBAction func onBackButtonTap(sender: AnyObject) {
        delegate?.didReturnFromTweetDetail!(currentTweetIndexPath)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onRetweetTap(gestureRecognizer: UITapGestureRecognizer) {
        tweet.didUserRetweet = !tweet.didUserRetweet
        loadDynamicUiElements()
        if (tweet.didUserRetweet) {
            // retweet
            User.currentUser?.retweet(tweet.idString, completion: { (error) -> () in
                if (error != nil) {
                    print("Error retweeting")
                }
            })
        } else {
            // TODO : Un retweet
        }
    }
    
    @IBAction func onFavoriteTap(gestureRecognizer: UITapGestureRecognizer) {
        tweet.didUserFavorite = !tweet.didUserFavorite
        loadDynamicUiElements()
        if (tweet.didUserFavorite) {
            // favorite
            User.currentUser?.favoriteTweet(tweet.idString, completion: { (error) -> () in
                if (error != nil) {
                    print("Error favoriting")
                }
            })
        } else {
            // TODO: un favorite
            
        }
    }
}
