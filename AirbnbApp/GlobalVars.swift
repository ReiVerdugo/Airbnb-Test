//
//  GlobalVars.swift
//  AirbnbApp
//
//  Created by devstn5 on 2016-09-16.
//  Copyright © 2016 NextDots. All rights reserved.
//

import Foundation

// Makes the color needed from the HEX color code
func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

class SomeManager {
 
    // Primary color from Airbnb
    var primaryColor = UIColorFromRGB(0xFF5A5F)
    
    // Secondary color
    var secondaryColor = UIColor.blackColor()
    
    
    //Current city
    var currentCity = "Venezuela"
    var sentToken = false
    var phoneToken : NSString = ""
    var usingMap = false
    static let sharedInstance = SomeManager()

}