//
//  CustomTabBarController.swift
//  AirbnbApp
//
//  Created by devstn5 on 2016-09-19.
//  Copyright © 2016 NextDots. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tabBar.tintColor = SomeManager.sharedInstance.primaryColor
        
        let tabItems = self.tabBar.items! as [UITabBarItem]
        let profileItem = tabItems[0] as UITabBarItem
        let listingItem = tabItems[1] as UITabBarItem
        let mapItem = tabItems[2] as UITabBarItem
        
        profileItem.title = (NSLocalizedString("Perfil", comment: ""))
        listingItem.title = (NSLocalizedString("Listado", comment: ""))
        mapItem.title = (NSLocalizedString("Mapa", comment: ""))
    }
}
