//
//  CoreLocationController.swift
//  Akizta
//
//  Created by Daniela Rodriguez on 7/9/15.
//  Modified by Daniela Rodriguez on 3/10/15.
//  Copyright (c) 2015 AMS. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


protocol CoreLocationControllerDelegate {
    func coreLocation(controller: CoreLocationController, changed: Bool)
    
}


class CoreLocationController: NSObject,CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager = CLLocationManager()
    var delegate: CoreLocationControllerDelegate?
    var lastCity = ""
    
    static let sharedInstance = CoreLocationController()

    let defaults = NSUserDefaults.standardUserDefaults()

    override init() {
        super.init()
    
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.distanceFilter  = 600 // Must move at least 600mts
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        self.locationManager.pausesLocationUpdatesAutomatically = true

    }


    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        
        switch status {
        case .NotDetermined:
            Router.location = "Venezuela"
            print(".NotDetermined")
            break
            
        case .AuthorizedAlways:
            print(".AuthorizedAlways")
            self.locationManager.startUpdatingLocation()
            break
            
        case .AuthorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            print(".AuthorizedWhenInUse")
            
            defaults.setObject("true", forKey: "gps")

            
            break;
            
        case .Denied:
            Router.location = "Venezuela"
            print(".Denied")
            break
            
        default:
            print("Unhandled authorization status")
            break
            
        }
    }
    
    func updateLocation(){
        self.lastCity = ""
        self.locationManager.stopUpdatingLocation()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager,
        didFailWithError error: NSError){
            print(error)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last as CLLocation?
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location!, completionHandler: { (placemarks, e) -> Void in
            if let _ = e {
                print("Error:  \(e!.localizedDescription)")
            } else {
                let placemark = placemarks!.last! as CLPlacemark
                
                if let useGps = self.defaults.stringForKey("gps") {
                    
                    if useGps == "true"{

                        SomeManager.sharedInstance.currentCity = placemark.locality!
                        
                        if self.lastCity != placemark.locality!{
                            
                            self.lastCity = placemark.locality!
                            self.delegate?.coreLocation(self, changed: true)
                            
                            
                            
                        }
                        
                        
                    }
                    
                }


            }
        })
        
        let lat = Double(location!.coordinate.latitude)
        let lon = Double(location!.coordinate.longitude)

        
        let latText:String = String(format: "%.4f", lat)
        let lonText:String = String(format: "%.4f", lon)
        
        print("TEXTOS: \(latText) y \(lonText)")
            
        if let useGps = defaults.stringForKey("gps") {
            if useGps == "true"{

                Router.location = "\(lonText),\(latText)"


            }
            
        }


    

    }
}
