//
//  ViewController.swift
//  FacebookTutorial
//
//  Created by Brian Coleman on 2015-03-27.
//  Copyright (c) 2015 Brian Coleman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    /*!
     @abstract Sent to the delegate when the button was used to login.
     @param loginButton the sender
     @param result The results of the login
     @param error The error (if any) from the login
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginView = FBSDKLoginButton()
        self.view.addSubview(loginView)
        loginView.center = self.view.center
        loginView.readPermissions = [ "public_profile", "email" ]
        loginView.delegate = self
        if (FBSDKAccessToken.current() != nil) {
            self.returnUserData()
        }
        else {
            loginView.delegate = self
        }
    }

    // Facebook Delegate Methods
    
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In (Error)")
        if ((error) != nil) {
            print("Error: \(error)")
        }
        else if result.isCancelled {
        }
        else {
            if result.grantedPermissions.contains("email") {
                // Do work
            }
            self.returnUserData()
        }
    }

    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In (NSError)")
        
        if ((error) != nil) {
            print("NSError: \(error)")
        }
        else if result.isCancelled {
        }
        else {
            if result.grantedPermissions.contains("email") {
                // Do work
            }
            self.returnUserData()
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData() {
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            print("\n -> graphRequest\n")
            if ((error) != nil) {
                print("Error: \(error)")
            }
            else {
                if let jsonResult = result as? Dictionary<String, Any> {
                    print("\n\n -> fetched user: \(jsonResult) \(jsonResult["name"] as! String)\n\n")
                }
            }
        })
    }
}

