//
//  DetailView.swift
//  AirbnbApp
//
//  Created by Reinaldo Verdugo on 17/9/16.
//  Copyright © 2016 NextDots. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON

class DetailView: UIViewController {

    // Outlets
    @IBOutlet weak var listingView: UIImageView!
    @IBOutlet weak var listingName: UILabel!
    @IBOutlet weak var listingType: UILabel!
    @IBOutlet weak var bedroomType: UILabel!
    @IBOutlet weak var numberOfGuests: UILabel!
    @IBOutlet weak var numberOfBedrooms: UILabel!
    
    @IBOutlet weak var numberOfBathrooms: UILabel!
    @IBOutlet weak var numberOfBeds: UILabel!
    @IBOutlet weak var listingDescription: UILabel!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var listingAddress: UILabel!
    
    
    var listingID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar(NSLocalizedString("Detalle", comment: ""))
    }

   
}
