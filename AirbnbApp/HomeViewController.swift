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
import CoreData

class ListingClass {
    var info : JSON = []
}

class HomeViewController : UIViewController, SaveInFavoritesProtocol {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var limit = 30
    var listings = [ListingClass]()
    var collectionDataSource = CollectionViewDataSource()
    var selectedListingId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar(NSLocalizedString("Listado", comment: ""))
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
            print(info)
            let cell = cell as! ListingCell
            cell.listingName.text = info["listing"]["name"].stringValue
            cell.listingType.text = info["listing"]["property_type"].stringValue
            let price = info["pricing_quote"]["listing_currency"].stringValue + " " + info["pricing_quote"]["nightly_price"].stringValue
            cell.price.text = price
            cell.listingImage.downloadImageFrom(link: info["listing"]["picture_url"].stringValue, contentMode: .ScaleAspectFit)
            cell.buttonProtocol = self
//            self.collectionView.indexPathForCell(cell)
//            if cell.likeSelected {
//                cell.likeButton.setImage(UIImage(named: "like-selected"), forState: .Normal)
//            } else {
//                cell.likeButton.setImage(UIImage(named: "like"), forState: .Normal)
//            }
//            print(cell.likeSelected)
            
        }
        self.collectionDataSource = CollectionViewDataSource(anItems: listings, cellIdentifier: "listingCell", aconfigureCellBlocks: configureCell)
        self.collectionDataSource.didSelectBlock = {indexPath in self.didSelect(indexPath)}
        self.collectionView.dataSource = self.collectionDataSource
        self.collectionView.delegate = collectionDataSource
        
    }
    
    func didSelect (indexPath : NSIndexPath) {
        selectedListingId = listings[indexPath.row].info["listing"]["id"].stringValue
        self.performSegueWithIdentifier("detail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            let nextController = segue.destinationViewController as! DetailView
            nextController.listingID = selectedListingId
        }
    }
    
    func saveFavorite(cell: ListingCell) {
        cell.likeSelected = !cell.likeSelected
        if cell.likeSelected {
            let indexPath = self.collectionView.indexPathForCell(cell)
            let info = self.listings[indexPath!.row].info
            let appDelegate =
                UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            //2
            let entity =  NSEntityDescription.entityForName("Housing",
                                                            inManagedObjectContext:managedContext)
            
            let listing = NSManagedObject(entity: entity!,
                                         insertIntoManagedObjectContext: managedContext)
            listing.setValue(info["listing"]["name"].stringValue, forKey: "name")
            listing.setValue(info["listing"]["id"].stringValue, forKey: "id")
            listing.setValue(info["listing"]["bathrooms"].stringValue, forKey: "bathrooms")
            listing.setValue(info["listing"]["public_address"].stringValue, forKey: "address")
            listing.setValue(info["listing"]["bedrooms"].stringValue, forKey: "bedrooms")
            listing.setValue(info["listing"]["beds"].stringValue, forKey: "beds")
            listing.setValue(info["listing"]["person_capacity"].stringValue, forKey: "guests")
            listing.setValue(info["listing"]["lat"].stringValue, forKey: "lat")
            listing.setValue(info["listing"]["lng"].stringValue, forKey: "lng")
            listing.setValue(info["pricing_quote"]["listing_currency"].stringValue + " " + info["pricing_quote"]["nightly_price"].stringValue, forKey: "price")
            listing.setValue(info["listing"]["property_type"].stringValue, forKey: "type")
            listing.setValue(info["listing"]["room_type"].stringValue, forKey: "roomType")
            
            let imageData = UIImagePNGRepresentation(cell.listingImage.image!);
            listing.setValue(imageData, forKey: "image")
            
            //4
            do {
                try managedContext.save()
                //5
                cell.likeButton.setImage(UIImage(named: "like-selected"), forState: .Normal)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }

        } else {
            cell.likeButton.setImage(UIImage(named: "like"), forState: .Normal)
        }
    }
    
}
