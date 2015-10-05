//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Soumya on 10/3/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

@objc protocol NewTweetCreatedDelegate {
    optional func newTweetCreated(tweet: Tweet?, error: NSError?)
}

let twitterBlue = UIColor(red: 70/255.0, green: 154/255.0, blue: 233/255.0, alpha: 1)

class NewTweetViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var numCharactersLeftLabel: UILabel!
    
    weak var delegate: NewTweetCreatedDelegate?
    var tweetReplyingTo: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.delegate = self
        
        showPlaceholderText()
        enableTweetButton(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // UI treatment
    func showPlaceholderText() {
        if (tweetReplyingTo == nil) {
            tweetTextView.text = "What's happening?"
            tweetTextView.textColor = UIColor.lightGrayColor()
        } else {
            tweetTextView.text = "@\(tweetReplyingTo!.author!.screenName!) "
            tweetTextView.textColor = UIColor.blackColor()

        }
    }
    
    func clearPlaceholderText() {
        tweetTextView.text = ""
        tweetTextView.textColor = UIColor.blackColor()
    }
    
    func enableTweetButton(enable: Bool) {
        tweetButton.layer.borderWidth = 1
        tweetButton.layer.cornerRadius = 3
        tweetButton.clipsToBounds = true
        tweetButton.enabled = enable
        
        if (enable) {
            tweetButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            tweetButton.backgroundColor = twitterBlue
            tweetButton.layer.borderColor = twitterBlue.CGColor
        } else {
            tweetButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            tweetButton.backgroundColor = UIColor.whiteColor()
            tweetButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        }        
    }

    // button actions
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        var parameters = [String : AnyObject]()
        parameters["status"] = tweetTextView.text
        if (tweetReplyingTo != nil) {
            // in case of reply to tweet we need to include the origin tweet's ID
            parameters["in_reply_to_status_id"] = tweetReplyingTo!.idString!
        }
        User.currentUser?.postTweet(parameters, completion: { (tweet, error) -> () in
            // call the delegate method to notify of new tweet created
            self.delegate?.newTweetCreated!(tweet, error: error)
        })
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Text view delegate methods
    func textViewDidBeginEditing(textView: UITextView) {
        if (tweetReplyingTo == nil) { // clear text when its not a reply
            clearPlaceholderText()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        enableTweetButton(!tweetTextView.text.isEmpty)
        let charsRemaining = 140 - textView.text.characters.count
        numCharactersLeftLabel.text = (charsRemaining >= 0)
            ? "\(charsRemaining)"
            : "Too long!"        
    }
    
    // TODO: keyboard delegate method to clip the keyboard    
}
