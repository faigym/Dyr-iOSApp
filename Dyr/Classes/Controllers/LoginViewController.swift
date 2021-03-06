//
//  LoginViewController.swift
//  Dyr
//
//  Created by Pieter Maene on 06/04/15.
//  Copyright (c) 2015 Student IT vzw. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func login(sender: AnyObject) {
        OAuthClient.sharedClient.accessTokenWithCredentials(username: username.text!, password: password.text!)
    }
    
    func presentNavigationController(notification: NSNotification) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewControllerWithIdentifier("NavigationController") as! NavigationController

        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "presentNavigationController:", name: OAuthClientReceivedAccessTokenNotification, object: nil)
    }
}