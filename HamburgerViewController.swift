//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by Soumya on 10/8/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

let TWEETS:String = "tweets"
let PROFILE:String = "profile"

class HamburgerViewController: HamburgerViewParentController {
    @IBOutlet var containerView: UIView!

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let currentUser = User.currentUser!
        userImageView.setImageWithURL(currentUser.profileImageUrl)
        userImageView.layer.cornerRadius = 3
        userImageView.clipsToBounds = true
        
        userNameLabel.text = currentUser.name
        screenNameLabel.text = "@\(currentUser.screenName!)"
        
        // take to tweets view controller
        showTweetsViewController()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func onProfileViewTap(sender: AnyObject) {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        vc.userScreenNameToShowProfile = User.currentUser!.screenName
        selectViewController(vc)
    }
    
    @IBAction func onTimelineTap(sender: AnyObject) {
        self.showTweetsViewController()
    }
    
    func showTweetsViewController() {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("TweetsViewController") as! TweetsViewController
        selectViewController(vc)
    }
    
    }
