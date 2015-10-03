//
//  TweetCell.swift
//  Twitter
//
//  Created by Soumya on 10/3/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTimeLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            userProfileImageView.setImageWithURL(tweet.author!.profileImageUrl)
            userNameLabel.text = tweet.author!.name
            screenNameLabel.text = "@\(tweet.author!.screenName!)"
            tweetTimeLabel.text = tweet.formatTimeElapsed()
            tweetTextLabel.text = tweet.text
            favoriteCountLabel.text = "\(tweet.favoriteCount!)"
            retweetCountLabel.text = "\(tweet.retweetCount!)"
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userProfileImageView.layer.cornerRadius = 3
        userProfileImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
