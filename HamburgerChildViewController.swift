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
    var startingMainViewCenter: CGPoint!
    weak var hamburgerChildViewDelegate: HamburgerChildViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "didPan:")
        self.view.addGestureRecognizer(panGesture)
        mainView = self.view
    }

    func didPan(panGestureRecognizer: UIPanGestureRecognizer) {
        switch(panGestureRecognizer.state) {
        case .Began:
            startingMainViewCenter = mainView.center
        case .Changed:
            let translation = panGestureRecognizer.translationInView(view)
            let isMovingRight = panGestureRecognizer.velocityInView(view).x > 0
            if (isMovingRight) {
                mainView.center.x = startingMainViewCenter.x + translation.x
            }
        case .Cancelled:
            restoreChildViewWithAnimation()
        case .Ended:
            let delta = (mainView.center.x - startingMainViewCenter.x) / mainView.frame.width
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
            self.mainView.center = self.startingMainViewCenter
        })
    }
    
    func closeChildViewWithAnimation() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.mainView.center.x = 3 * self.startingMainViewCenter.x
            }, completion: { (Bool) -> Void in
                self.hamburgerChildViewDelegate?.hamburgerChildViewControllerWantsToClose!(self)
        })
    }
}
