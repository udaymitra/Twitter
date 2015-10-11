//
//  TweetCell.swift
//  Twitter
//
//  Created by Soumya on 10/3/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate {
    optional func tweetCellProfileImageTapped(tweetCell: TweetCell)
}

class TweetCell: UITableViewCell {
    var delegate: TweetCellDelegate?
    
    @IBOutlet weak private var userProfileImageView: UIImageView!
    @IBOutlet weak private var userNameLabel: UILabel!
    @IBOutlet weak private var screenNameLabel: UILabel!
    @IBOutlet weak private var tweetTimeLabel: UILabel!
    
    @IBOutlet weak private var tweetTextLabel: UILabel!
    
    @IBOutlet weak private var replyImageView: UIImageView!
    @IBOutlet weak private var retweetImageView: UIImageView!
    @IBOutlet weak private var favoriteImageView: UIImageView!
    @IBOutlet weak private var retweetCountLabel: UILabel!
    @IBOutlet weak private var favoriteCountLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            userProfileImageView.setImageWithURL(tweet.author!.profileImageUrl)
            userNameLabel.text = tweet.author!.name
            screenNameLabel.text = "@\(tweet.author!.screenName!)"
            tweetTimeLabel.text = tweet.formatTimeElapsed()
            tweetTextLabel.text = tweet.text
            favoriteCountLabel.text = "\(tweet.favoriteCount!)"
            retweetCountLabel.text = "\(tweet.retweetCount!)"
            
            let retweetImageToShow = (tweet!.didUserRetweet) ? "retweet_on" : "retweet"
            retweetImageView.image = UIImage(named: retweetImageToShow)
            
            let favoriteImageToShow = (tweet!.didUserFavorite) ? "favorite_on" : "favorite"
            favoriteImageView.image = UIImage(named: favoriteImageToShow)
            
            let replyImageToShow = (tweet!.didUserReply) ? "reply_hover" : "reply"
            replyImageView.image = UIImage(named: replyImageToShow)
            
            userProfileImageView.userInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: "didTapOnProfileImage:")
            userProfileImageView.addGestureRecognizer(tapGesture)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userProfileImageView.layer.cornerRadius = 3
        userProfileImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func didTapOnProfileImage(tapGestureRecognizer: UITapGestureRecognizer) {
        self.delegate?.tweetCellProfileImageTapped!(self)
    }
}
