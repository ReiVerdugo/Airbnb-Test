//
//  ProfileViewController.swift
//  AirbnbApp
//
//  Created by devstn5 on 2016-09-16.
//  Copyright © 2016 NextDots. All rights reserved.
//

import UIKit
import FBSDKLoginKit

/**
Containts the methods to display the user's profile and info.
 
 From this controller's corresponding view, the user can access his/her favorites or logout from the application.
 */
class ProfileViewController: UITableViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var goToFavoritesLabel: UILabel!
    @IBOutlet weak var logoutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar(NSLocalizedString("Perfil", comment: ""))
        returnUserData()
        translateTexts()
    }
    
    /**
     It returns the user's profile and assigns it to the correspondant labels.
     
     ## Parameters set ##
     1. User profile picture.
     2. User first's and last's name.
     3. User's email.
     
     */
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, first_name, last_name, cover, picture.type(large)"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Log error
                print("Error: \(error)")
            }
            else
            {
                self.nameLabel.text = (result["first_name"] as! String) + " " + (result["last_name"] as! String)
                self.emailLabel.text = (result["email"] as! String)
                self.profileImage.downloadImageFrom(link: (result["picture"]!!["data"]!!["url"] as! String), contentMode: .ScaleAspectFill)
                self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
            }
        })
    }
    
    /**
     Set the code to execute when the user selects a cell.
     
     In this particular case, only the **fourth** row is specified. It executes the *logout* method from Facebook SDK.
     */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 4 {
            FBSDKLoginManager().logOut()
            self.performSegueWithIdentifier("home", sender: self)
        }
    }
    
    /**
     Translates the texts displaying in the current view.
     
     In this case, the labels translated are *goToFavoritesLabel* and *logoutLabel*.
     */
    func translateTexts () {
        goToFavoritesLabel.text = NSLocalizedString("Ir a mis favoritos", comment: "")
        logoutLabel.text = NSLocalizedString("Cerrar sesión", comment: "")
    }
    
}
