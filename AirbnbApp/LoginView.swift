//
//  LoginView.swift
//  AirbnbApp
//
//  Created by devstn5 on 2016-09-15.
//  Copyright © 2016 NextDots. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Alamofire

class LoginView : UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        // If user is already logged in
        if (FBSDKAccessToken.currentAccessToken() != nil){
            self.performSegueWithIdentifier("login", sender: nil)
        }
    }
    
    @IBAction func loginAction(sender: UIButton) {
        let idk = FBSDKLoginManager()
        idk.logInWithReadPermissions(["public_profile", "email"], handler: {
            
            (result, error) -> Void in
            if error != nil {
                print(FBSDKAccessToken.currentAccessToken())
            } else if result.isCancelled {
                print("Cancelled")
            } else {
                print("LoggedIn")
                self.performSegueWithIdentifier("login", sender: nil)
                
            }
        })

    }

}
