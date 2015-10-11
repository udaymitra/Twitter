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
    var startingMainViewCenter: CGPoint!
    weak var hamburgerChildViewDelegate: HamburgerChildViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "didPan:")
        self.view.addGestureRecognizer(panGesture)
    }

    func didPan(panGestureRecognizer: UIPanGestureRecognizer) {
        switch(panGestureRecognizer.state) {
        case .Began:
            startingMainViewCenter = self.view.center
        case .Changed:
            let translation = panGestureRecognizer.translationInView(view)
            let isMovingRight = panGestureRecognizer.velocityInView(view).x > 0
            if (isMovingRight) {
                self.view.center.x = startingMainViewCenter.x + translation.x
            }
        case .Cancelled:
            restoreChildViewWithAnimation()
        case .Ended:
            let delta = (self.view.center.x - startingMainViewCenter.x) / self.view.frame.width
            if (delta > 0.5) {
                closeChildViewWithAnimation()
            } else {
                restoreChildViewWithAnimation()
            }
        default:
            print("default case")
        }
    }
    
    func restoreChildViewWithAnimation() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.center = self.startingMainViewCenter
        })
    }
    
    func closeChildViewWithAnimation() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.center.x = 3 * self.startingMainViewCenter.x
            }, completion: { (Bool) -> Void in
                self.hamburgerChildViewDelegate?.hamburgerChildViewControllerWantsToClose!(self)
        })
    }
}
