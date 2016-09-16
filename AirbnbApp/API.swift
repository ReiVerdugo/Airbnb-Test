//
//  API.swift
//  Applicant Test
//
//  Created by devstn5 on 2016-08-24.
//  Copyright © 2016 NextDots. All rights reserved.
//
// Here we use Alamofire's library to create and set the URL and HTTP Requests.

import Foundation
import Alamofire

extension NSURLRequest {
    func encodeParameters(parameters: [String: AnyObject]) -> NSURLRequest {
        return Alamofire.ParameterEncoding.JSON.encode(self, parameters: parameters).0
    }
    func encodeURL(parameters: [String: AnyObject]) ->
        NSURLRequest {
            return Alamofire.ParameterEncoding.URL.encode(self, parameters: parameters).0
    }
}

// This enum help us create the request to easy access them from another controller

enum Router : URLRequestConvertible {
    // base URL to make requests
    static var baseURLString = "https://api.airbnb.com/v2/"
    static var location: String?
    static var parameters = []
    
    // Requests
    case getListings([String : AnyObject])
    case getListingInfo([String : AnyObject])
    
    // Requests methods
    var method: Alamofire.Method {
        switch self {
            
        case .getListings:
            return .GET
            
        case .getListingInfo:
            return .GET
        }
    }
    
    // Path to be added to each request
    var path: String {
        switch self {
    
        case .getListings:
            return "search_results"
        
        case .getListingInfo(let listingId):
            return "listings/\(listingId)"
        }
    }
    
    
    
    // Encoding URL or JSON (if needed) parameters
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue

        if let location = Router.location {
            mutableURLRequest.setValue(location, forHTTPHeaderField: "X-Geolocation")
            
        }
        
        switch self {
            
        case .getListings(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            
        case .getListingInfo(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            
        default:
            return mutableURLRequest
        }
        
    }
    
    
}
