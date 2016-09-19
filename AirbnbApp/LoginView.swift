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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if (FBSDKAccessToken.currentAccessToken() != nil){
            // User is already logged in, do work such as go to next view controller.
            self.performSegueWithIdentifier("login", sender: nil)
        }
    }
    
    @IBAction func loginAction(sender: UIButton) {
        let idk = FBSDKLoginManager()
        idk.logInWithReadPermissions(["public_profile", "email"], handler: {
            
            (result, error) -> Void in
            if error != nil {
                print(FBSDKAccessToken.currentAccessToken())
                print("Entre aqui")
            } else if result.isCancelled {
                print("Cancelled")
            } else {
                print(result)
                print("LoggedIn")
//                "token":FBSDKAccessToken.currentAccessToken().tokenString,
                self.performSegueWithIdentifier("login", sender: nil)
                
            }
        })

    }
    
    

}
