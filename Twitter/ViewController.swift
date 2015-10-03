//
//  ViewController.swift
//  Twitter
//
//  Created by Soumya on 9/29/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        User.loginWithCompletion{ (user, error) -> () in
            if (user != nil) {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                print("error getting user: \(error)")
            }
        }        
    }

}

