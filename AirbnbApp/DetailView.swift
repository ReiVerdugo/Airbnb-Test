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
import CoreData

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
    var fromFavorites = false
    var currentFavorite : NSManagedObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        setNavBar(NSLocalizedString("Detalle", comment: ""))
        if fromFavorites {
            initFavorite()
        } else {
          getDetail()
        }
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
    
    /**
     Given a JSON-formatted-information, initializes all the labels, maps, and images from the current view
     
     - parameter info: The JSON-formatted-information to be used
     */
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
        self.locations.append(locpin)
        self.points.addCoordinate(locpin)
        let locationMarker = GMSMarker(position: locpin)
        locationMarker.title = info["name"].stringValue
        locationMarker.snippet = info["price_formatted"].stringValue
        
        self.markers.insert(locationMarker)

    }
    
    /**
     Moves the camera to the marker added, so the location of the housing is in the middle of the map
     */
    func setUpMap() {
        let locpin = self.locations[0]
        let camera: GMSCameraUpdate = GMSCameraUpdate.setTarget(locpin, zoom: 16)
        self.mapView.animateWithCameraUpdate(camera)
    }
    
    /**
     For each marker in the current view, draw it in the map, if it's not already drawn
     */
    func drawMarkers () {
        for marker in self.markers {
            if marker.map == nil {
                marker.map = self.mapView
            }
        }
        
    }
    
    /**
     If the user comes from favorites, initializes all the labels with the stored favorite housing's information.
     */
    func initFavorite () {
        if let info = currentFavorite {
            self.listingName.text = info.valueForKey("name") as? String
            self.listingType.text = info.valueForKey("type") as? String
            self.bedroomType.text = info.valueForKey("roomType") as? String
            self.numberOfGuests.text = info.valueForKey("guests") as? String
            self.numberOfBedrooms.text = info.valueForKey("bedrooms") as? String
            self.numberOfBeds.text = info.valueForKey("beds") as? String
            self.numberOfBathrooms.text = info.valueForKey("bathrooms") as? String
            self.listingDescription.text = ""
            self.listingAddress.text = info.valueForKey("address") as? String
            self.price.text = info.valueForKey("price") as? String
            let imageData = info.valueForKey("image") as? NSData
            self.listingView.image = UIImage(data: imageData!)
            
            // Location
            let locpin = CLLocationCoordinate2D(latitude: Double(info.valueForKey("lat") as! String)!, longitude: Double(info.valueForKey("lng") as! String)!)
            self.locations.append(locpin)
            self.points.addCoordinate(locpin)
            let locationMarker = GMSMarker(position: locpin)
            locationMarker.title = info.valueForKey("name") as? String
            locationMarker.snippet = info.valueForKey("price") as? String
            self.markers.insert(locationMarker)
            
            self.drawMarkers()
            self.setUpMap()
        }
    }
}
