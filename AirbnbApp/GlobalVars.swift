//
//  GlobalVars.swift
//  Beset Bear
//
//  Created by Daniela Rodriguez on 7/15/15.
//  Copyright (c) 2015 AMS. All rights reserved.
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
 
    //Orange
    var primaryColor = UIColorFromRGB(0xFE5000)
    
    //Blue
    var secondaryColor = UIColorFromRGB(0x009DDC)
    
    
    //Current city
    var currentCity = "Venezuela"
    
    var sentToken = false
    
    var phoneToken : NSString = ""
    
    var listId = ""
    
    var usingMap = false
    
    static let sharedInstance = SomeManager()

}