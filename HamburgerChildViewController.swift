//
//  HamburgerChildViewController.swift
//  Twitter
//
//  Created by Soumya on 10/9/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

@objc protocol HamburgerChildViewControllerDelegate {
    optional func hamburgerChildViewControllerWantsToClose(childViewController: HamburgerChildViewController)
}

class HamburgerChildViewController: UIViewController {
    @IBOutlet var mainView: UIView!
    var startingMainViewCenterX: CGFloat!
    weak var hamburgerChildViewDelegate: HamburgerChildViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "didPan:")
        self.view.addGestureRecognizer(panGesture)
        mainView = self.view
    }

    func didPan(panGestureRecognizer: UIPanGestureRecognizer) {
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            startingMainViewCenterX = mainView.center.x
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            let translation = panGestureRecognizer.translationInView(view)
            let isMovingRight = panGestureRecognizer.velocityInView(view).x > 0
            if (isMovingRight) {
                mainView.center.x = startingMainViewCenterX + translation.x
            }
            let delta = (mainView.center.x - startingMainViewCenterX) / mainView.frame.width
            if (delta > 0.7) {
                // jump to hamburger view
                print("Jump to hamburger view")
                hamburgerChildViewDelegate?.hamburgerChildViewControllerWantsToClose!(self)
            }
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Cancelled {
            mainView.center.x = startingMainViewCenterX
        }
    }
}
