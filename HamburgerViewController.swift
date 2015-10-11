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

class HamburgerViewController: UIViewController, HamburgerChildViewControllerDelegate {
    @IBOutlet var containerView: UIView!
    var selectedViewController: HamburgerChildViewController?
    
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
        selectViewController(vc)
    }
    
    @IBAction func onTimelineTap(sender: AnyObject) {
        self.showTweetsViewController()
    }
    
    func showTweetsViewController() {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("TweetsViewController") as! TweetsViewController
        selectViewController(vc)
    }
    
    func selectViewController(viewController: HamburgerChildViewController) {
        self.addChildViewController(viewController)
        viewController.view.frame = self.containerView.bounds
        viewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.containerView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        selectedViewController = viewController
        selectedViewController!.hamburgerChildViewDelegate = self
    }
    
    func hamburgerChildViewControllerWantsToClose(childViewController: HamburgerChildViewController) {
        if let oldViewController = selectedViewController {
            oldViewController.willMoveToParentViewController(nil)
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParentViewController()
            
            print("closed child view")
        }
    }
}
