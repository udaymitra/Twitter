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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onProfileViewTap(sender: AnyObject) {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        selectViewController(vc)
    }
    
    @IBAction func onTimelineTap(sender: AnyObject) {
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
        }
    }
}
