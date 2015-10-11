//
//  HamburgerViewParent.swift
//  Twitter
//
//  Created by Soumya on 10/11/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class HamburgerViewParentController: UIViewController, HamburgerChildViewControllerDelegate {
    var selectedViewController: HamburgerChildViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func selectViewController(viewController: HamburgerChildViewController) {
        self.addChildViewController(viewController)
        viewController.view.frame = self.view.bounds
        viewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.view.addSubview(viewController.view)
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
