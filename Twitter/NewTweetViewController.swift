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

class NewTweetViewController: UIViewController, UITextViewDelegate {
    let twitterBlue = UIColor(red: 70/255.0, green: 154/255.0, blue: 233/255.0, alpha: 1)
    
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var numCharactersLeftLabel: UILabel!
    
    weak var delegate: NewTweetCreatedDelegate?
    
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
        tweetTextView.text = "What's happening?"
        tweetTextView.textColor = UIColor.lightGrayColor()
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
        User.currentUser?.postTweet(parameters, completion: { (tweet, error) -> () in
            // call the delegate method to notify of new tweet created
            self.delegate?.newTweetCreated!(tweet, error: error)
        })
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Text view delegate methods
    func textViewDidBeginEditing(textView: UITextView) {
        clearPlaceholderText()
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
