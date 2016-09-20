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
import GoogleMaps

class ListingClass {
    var info : JSON = []
}

class HomeViewController : UIViewController, SaveInFavoritesProtocol {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var limit = 30
    var listings = [ListingClass]()
    var collectionDataSource = CollectionViewDataSource()
    var collectionDelegate = CollectionViewDelegate()
    var selectedListingId = ""
    var currentCity = ""
    var favoritesDictionary : [String] = []
    
    // ***************************************
    // MARK: - UIViewController Methods
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        initDictionary()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar(NSLocalizedString("Listado", comment: ""))
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate((CoreLocationController.sharedInstance.locationManager.location?.coordinate)!, completionHandler: {
            (response, error) -> Void in
            let throughfare = (response?.firstResult()!.thoroughfare!)!
            let city = (response?.firstResult()!.locality!)!
            self.currentCity = throughfare + " " + city
            self.getListings()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            let nextController = segue.destinationViewController as! DetailView
            nextController.listingID = selectedListingId
        }
    }
    
    /**
     Changes the layout of the collectionView according to device's current size.
     It also supports landscape/portrait orientations
     
     */
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        if (self.view.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Compact) {
            self.collectionDelegate.width = 1
            self.collectionDelegate.height = 0.5
            self.collectionView.reloadData()
        } else {
            self.collectionDelegate.width = 0.5
            self.collectionDelegate.height = 1
            self.collectionView.reloadData()
        }
    }
    
    // ***************************************
    // MARK: - User created methods
    
    /**
     It returns the list of housings near the current user's location.
     
     ## Parameters used to get data ##
     - Parameter clientid: An specific client_id to get data from API.
     - Parameter limit: The maximum number of housings to get (in this case it's 30).
     - Parameter location: User's current city, parameter obtained from *ViewDidLoad*'s method.
     - Parameter userlat: The user's current latitude (this actually doesn't affect the search)
     - Parameter userlng: The user's current longitude (doesn't affect the search either)
     
     */
    func getListings () {
        SVProgressHUD.showWithStatus(NSLocalizedString("Cargando alojamientos", comment: ""))
        let parameters : [String: AnyObject] = [
            "client_id" : "3092nxybyb0otqw18e8nh5nty",
            "_limit" : limit,
            "location" : self.currentCity,
            "user_lat" : (CoreLocationController.sharedInstance.locationManager.location?.coordinate.latitude)!,
            "user_lng" : (CoreLocationController.sharedInstance.locationManager.location?.coordinate.longitude)!
        ]
        Alamofire.request(Router.getListings(parameters))
            .validate()
            .responseJSON { response in
                
                if response.result.isSuccess {
                    let listingInfo = JSON(response.result.value!)["search_results"].arrayValue
                    for listing in listingInfo {
                        let list = ListingClass()
                        list.info = listing
                        self.listings.append(list)
                    }
                }else{
                    print(response.debugDescription)
                    
                }
                self.collectionView.reloadData()
                self.setCollection()
                SVProgressHUD.dismiss()
        }
    }
    
    
    /**
     Set's the CollectionView *Delegate* and *DataSource*, and configures the corresponding methods to be used inside them.
     
     ## Parameters used to get data ##
     - Parameter clientid: An specific client_id to get data from API.
     - Parameter limit: The maximum number of housings to get (in this case it's 30).
     - Parameter location: User's current city, parameter obtained from *ViewDidLoad*'s method.
     - Parameter userlat: The user's current latitude (this actually doesn't affect the search)
     - Parameter userlng: The user's current longitude (doesn't affect the search either)
     
     */
    func setCollection(){
        
        // Configures how the cell are going to be displayed, to be used as a parameter inside the *cellForItemAtIndexPath* method, from the *CollectionViewDataSource*
        let configureCell: CollectionViewCellConfigureBlock = {cell,listing in
            let info = (listing as! ListingClass).info
            let cell = cell as! ListingCell
            cell.listingName.text = info["listing"]["name"].stringValue
            cell.listingType.text = info["listing"]["property_type"].stringValue
            let price = info["pricing_quote"]["listing_currency"].stringValue + " " + info["pricing_quote"]["nightly_price"].stringValue
            cell.price.text = price
            cell.listingImage.downloadImageFrom(link: info["listing"]["picture_url"].stringValue, contentMode: .ScaleToFill)
            cell.buttonProtocol = self
            
            // Set favorite icon accordinly
            if self.favoritesDictionary.contains(info["listing"]["id"].stringValue) {
                cell.likeButton.setImage(UIImage(named: "like-selected"), forState: .Normal)
                cell.likeSelected = true
            } else {
                cell.likeButton.setImage(UIImage(named: "like"), forState: .Normal)
                cell.likeSelected = false
            }
            
        }
        self.collectionDataSource = CollectionViewDataSource(anItems: listings, cellIdentifier: "listingCell", aconfigureCellBlocks: configureCell)
        self.collectionDelegate.didSelectBlock = {indexPath in self.didSelect(indexPath)}
        self.collectionView.dataSource = self.collectionDataSource
        self.collectionView.delegate = self.collectionDelegate
        
    }
    
    /**
     Configures the closure to be passed as a parameter to the CollectionDelegate, so it sets the code to be execute when the uses selects a cell.
     In this case, it gets the selected housing's Id to be used in the request from the detail view.
     
     */
    func didSelect (indexPath : NSIndexPath) {
        selectedListingId = listings[indexPath.row].info["listing"]["id"].stringValue
        self.performSegueWithIdentifier("detail", sender: self)
    }
    
    
    /**
     Saves the seleted housing to Favorites so it can be accessed anytime, even without Internet access.

     - Parameter cell: The ListingCell selected.
   
     ## Important notes ##
     1. If the cell is not marked as favorite, it will mark it and save it, so it can be accessed from the profile view, *go to favorites* option.
     2. If the cell was marked as favorite already, it will remove it from users' favorites and it will change the icon
     */
    func saveFavorite(cell: ListingCell) {
        cell.likeSelected = !cell.likeSelected
        let indexPath = self.collectionView.indexPathForCell(cell)
        let info = self.listings[indexPath!.row].info
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // If the cell is now selected, save it to favorites
        if cell.likeSelected {
            
            let entity =  NSEntityDescription.entityForName("Housing",
                                                            inManagedObjectContext:managedContext)
            let listing = NSManagedObject(entity: entity!,
                                         insertIntoManagedObjectContext: managedContext)
            // Saving the housing attributes
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
            
            // Save in context
            do {
                try managedContext.save()
                //5
                cell.likeButton.setImage(UIImage(named: "like-selected"), forState: .Normal)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }

        // If the cell is now deselected, remove from favorites
        } else {
            let request = NSFetchRequest(entityName: "Housing")
            request.returnsObjectsAsFaults = false;
            let id = info["listing"]["id"].stringValue
            let resultPredicate = NSPredicate(format: "id = %@", id)
            request.predicate = resultPredicate
            do {
                // Fetch result
                let result =
                    try managedContext.executeFetchRequest(request)[0]
                
                managedContext.deleteObject(result as! NSManagedObject)
                
                // Save deletion
                do {
                    try managedContext.save()
                    cell.likeButton.setImage(UIImage(named: "like"), forState: .Normal)
                    self.favoritesDictionary.append(id)
                } catch let error as NSError {
                    print("Could not save  \(error), \(error.userInfo)")
                }
                
                
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }

        }
    }
    
    /**
     Initializes an array with the id of the favorite housings, to get a quick access to them and verify if a gotten housing is already favorite or not.
     */
    func initDictionary () {
        self.favoritesDictionary.removeAll()
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Housing")
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            let favorites = results as! [NSManagedObject]
            for favorite in favorites {
                let id = favorite.valueForKey("id") as! String
                self.favoritesDictionary.append(id)
                
            }
            self.collectionView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }


    }
    
    
    
}
