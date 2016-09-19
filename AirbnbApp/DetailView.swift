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

class DetailView: UIViewController, GMSMapViewDelegate {

    // Outlets
    @IBOutlet weak var listingView: UIImageView!
    @IBOutlet weak var price: UILabel!
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
    
    // Properties
    var listingID = ""
    var locations : [CLLocationCoordinate2D] = []
    var points : GMSMutablePath = GMSMutablePath()
    var markers : Set<GMSMarker> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        setNavBar(NSLocalizedString("Detalle", comment: ""))
        getDetail()
    }
    
    func getDetail () {
        let parameters : [String: AnyObject] = [
            "client_id" : "3092nxybyb0otqw18e8nh5nty",
            "_format" : "v1_legacy_for_p3"
        ]
        Router.parameters = [listingID]
        Alamofire.request(Router.getListingInfo(parameters))
            .validate()
            .responseJSON { response in
                
            if response.result.isSuccess {
                let listingInfo = JSON(response.result.value!)["listing"]
                self.setLabels(listingInfo)
                    
            }else{
                print(response.debugDescription)
                    
            }
            self.drawMarkers()
            self.setUpMap()
        }

    }
    
    func setLabels (info : JSON) {
        self.listingName.text = info["name"].stringValue
        self.listingType.text = info["property_type"].stringValue
        self.bedroomType.text = info["room_type"].stringValue
        self.numberOfGuests.text = info["person_capacity"].stringValue
        self.numberOfBedrooms.text = info["bedrooms"].stringValue
        self.numberOfBeds.text = info["beds"].stringValue
        self.numberOfBathrooms.text = info["bathrooms"].stringValue
        self.listingDescription.text = info["description"].stringValue
        self.listingAddress.text = info["address"].stringValue
        self.price.text = info["price_formatted"].stringValue
        self.listingView.downloadImageFrom(link: info["picture_url"].stringValue, contentMode: .ScaleAspectFit)
        // Location
        let locpin = CLLocationCoordinate2D(latitude: Double(info["lat"].stringValue)!, longitude: Double(info["lng"].stringValue)!)
        print(locpin)
        self.locations.append(locpin)
        self.points.addCoordinate(locpin)
        let locationMarker = GMSMarker(position: locpin)
        locationMarker.title = info["name"].stringValue
        locationMarker.snippet = info["price_formatted"].stringValue
        
        self.markers.insert(locationMarker)

    }
    
    // Move the camera to see all the markers added
    func setUpMap() {
        let locpin = self.locations[0]
        let camera: GMSCameraUpdate = GMSCameraUpdate.setTarget(locpin, zoom: 16)
        self.mapView.animateWithCameraUpdate(camera)
    }
    
    func drawMarkers () {
        for marker in self.markers {
            if marker.map == nil {
                marker.map = self.mapView
            }
        }
        
    }


   
}
