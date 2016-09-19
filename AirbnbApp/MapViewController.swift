//
//  MapViewController.swift
//  AirbnbApp
//
//  Created by devstn5 on 2016-09-16.
//  Copyright © 2016 NextDots. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import SVProgressHUD

class MapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    var limit = 30
    var listings = [ListingClass]()
    
    // Location stuff
    var locations : [CLLocationCoordinate2D] = []
    var points : GMSMutablePath = GMSMutablePath()
    var markers : Set<GMSMarker> = []
    var currentCity = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar(NSLocalizedString("Mapa", comment: ""))
        self.mapView.delegate = self
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate((CoreLocationController.sharedInstance.locationManager.location?.coordinate)!, completionHandler: {
            (response, error) -> Void in
            let throughfare = (response?.firstResult()!.thoroughfare!)!
            let city = (response?.firstResult()!.locality!)!
            self.currentCity = throughfare + " " + city
            self.getListings()
        })

    }
    
    func getListings () {
        SVProgressHUD.showWithStatus(NSLocalizedString("Cargando alojamientos", comment: ""))
        let parameters : [String: AnyObject] = [
            "client_id" : "3092nxybyb0otqw18e8nh5nty",
            "_limit" : limit,
            "location" : self.currentCity,
            "user_lat" : (CoreLocationController.sharedInstance.locationManager.location?.coordinate.latitude)!,
            "user_lng" : (CoreLocationController.sharedInstance.locationManager.location?.coordinate.longitude)!
        ]
        print(parameters)
        
        Alamofire.request(Router.getListings(parameters))
            .validate()
            .responseJSON { response in
                
                if response.result.isSuccess {
                    let listingInfo = JSON(response.result.value!)["search_results"].arrayValue
                    for listing in listingInfo {
                        let list = ListingClass()
                        list.info = listing
                        self.listings.append(list)
                        
                        // Locations
                        var locationMarker: GMSMarker!
                        let locpin = CLLocationCoordinate2D(latitude: Double(listing["listing"]["lat"].stringValue)!, longitude: Double(listing["listing"]["lng"].stringValue)!)
                        self.locations.append(locpin)
                        self.points.addCoordinate(locpin)
                        
                        locationMarker = GMSMarker(position: locpin)
                        locationMarker.title = listing["listing"]["name"].stringValue
                        locationMarker.snippet = listing["pricing_quote"]["listing_currency"].stringValue + " " + listing["pricing_quote"]["nightly_price"].stringValue
                        
                        if listing["listing"]["property_type"].stringValue == "Apartment" {
                            locationMarker.icon = UIImage(named: "apartment-icon")
                        } else if listing["listing"]["property_type"].stringValue == "House" {
                            locationMarker.icon = UIImage(named: "house-icon")
                        } else {
                            locationMarker.icon = UIImage(named: "bed-icon")
                        }
                        
                        self.markers.insert(locationMarker)

                    }
                    self.drawMarkers()
                    self.setUpMap()
                }else{
                    SVProgressHUD.showErrorWithStatus("Error. Please try again")
                    print(response.debugDescription)
                    
                }
                SVProgressHUD.dismiss()
        }
    }
    // Move the camera to see all the markers added
    func setUpMap() {
        self.mapView.myLocationEnabled = true
        var camera = GMSCameraPosition()
        camera = GMSCameraPosition.cameraWithLatitude((CoreLocationController.sharedInstance.locationManager.location?.coordinate.latitude)!, longitude: (CoreLocationController.sharedInstance.locationManager.location?.coordinate.longitude)!, zoom: 18.0)
        self.mapView.camera = camera
        
    }
    
    func drawMarkers () {
        for marker in self.markers {
            if marker.map == nil {
                marker.map = self.mapView
            }
        }
        
    }

   
    
}
