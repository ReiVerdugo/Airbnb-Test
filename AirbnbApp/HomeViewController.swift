//
//  HomeViewController.swift
//  AirbnbApp
//
//  Created by devstn5 on 2016-09-15.
//  Copyright © 2016 NextDots. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class ListingClass {
    var info : JSON = []
}

class HomeViewController : UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var limit = 30
    var listings = [ListingClass]()
    var collectionDataSource = CollectionViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListings()
    }
    
    func getListings () {
        let parameters : [String: AnyObject] = [
            "client_id" : "3092nxybyb0otqw18e8nh5nty",
            "_limit" : limit
        ]
        Alamofire.request(Router.getListings(parameters))
            .validate()
            .responseJSON { response in
                
                if response.result.isSuccess {
//                    SVProgressHUD.showSuccessWithStatus("Artists found")
                    let listingInfo = JSON(response.result.value!)["search_results"].arrayValue
                    print(listingInfo)
                    for listing in listingInfo {
                        let list = ListingClass()
                        list.info = listing
                        self.listings.append(list)
                    }
                }else{
//                    SVProgressHUD.showErrorWithStatus("Error. Please try again")
                    print(response.debugDescription)
                    
                }
                self.collectionView.reloadData()
                self.setCollection()

        }
    }
    
    func setCollection(){
        
        let configureCell: CollectionViewCellConfigureBlock = {cell,listing in
            let info = (listing as! ListingClass).info
            let cell = cell as! ListingCell
            cell.listingName.text = info["listing"]["name"].stringValue
            cell.listingType.text = info["listing"]["property_type"].stringValue
            let price = info["pricing_quote"]["listing_currency"].stringValue + " " + info["pricing_quote"]["nightly_price"].stringValue
            cell.price.text = price
            cell.listingImage.downloadImageFrom(link: info["listing"]["picture_url"].stringValue, contentMode: .ScaleAspectFit)

            
        }
        self.collectionDataSource = CollectionViewDataSource(anItems: listings, cellIdentifier: "listingCell", aconfigureCellBlocks: configureCell)
        self.collectionView.dataSource = self.collectionDataSource
        self.collectionView.delegate = collectionDataSource
        
    }

    
}
