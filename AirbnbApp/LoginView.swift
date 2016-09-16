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
            print(FBSDKAccessToken.currentAccessToken().tokenString)
            returnUserData()
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
                self.returnUserData()
                let param = [
                    "token":FBSDKAccessToken.currentAccessToken().tokenString,
                    "version":"3.0",
                    "agent":"iOS",
                    
                ]
                self.performSegueWithIdentifier("login", sender: nil)
                
            }
        })

    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, first_name, last_name, picture"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
//                let userName : NSString = result.valueForKey("name") as! NSString
//                print("User Name is: \(userName)")
//                let userEmail : NSString = result.valueForKey("email") as! NSString
//                print("User Email is: \(userEmail)")
//                let image : NSString = result.valueForKey("imageUrl") as! NSString
//                print("Image is: \(image)")
                
            }
        })
    }

}
