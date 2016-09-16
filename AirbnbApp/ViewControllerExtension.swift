//
//  ViewControllerExtension.swift
//  Applicant Test
//
//  Created by devstn5 on 2016-08-24.
//  Copyright © 2016 KogiMobile. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


// This extension allows to create global functions
// available to all ViewControllers and TableViewController to simplify some basic functionalities

extension UIViewController {
    
    // Sets navigation bar title, tint and bar color, as well as the back button item title and any needed atributes
    func setNavBar(title: String){
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),
                                                                        NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!
                                                                        ]
        self.navigationItem.title = title;
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
    }
    
    // Makes the color needed from the HEX color code
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // Simplifies showing an alert controller
    func throwBasicAlert(title: String, message: String, actions: [(String, UIAlertAction! -> Void)]) {
        let alertController = UIAlertController(title: title, message: message as String, preferredStyle: .Alert)
        for (actionTitle, actionHandler) in actions {
            alertController.addAction(UIAlertAction(title: actionTitle, style: .Default, handler: actionHandler))
        }
        alertController.view.tintColor = UIColorFromRGB(0x24cf5f)
        
        //Present the AlertController
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

    // Simplifies the donwload of an image using an URL
    extension UIImageView {
        func downloadImageFrom(link link:String, contentMode: UIViewContentMode) {
        NSURLSession.sharedSession().dataTaskWithURL( NSURL(string:link)!, completionHandler: {
            (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
            }).resume()
        }
    }





