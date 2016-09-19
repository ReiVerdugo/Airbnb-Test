//
//  FavoritesView.swift
//  AirbnbApp
//
//  Created by devstn5 on 2016-09-19.
//  Copyright © 2016 NextDots. All rights reserved.
//

import UIKit
import CoreData

class FavoritesView: UIViewController, SaveInFavoritesProtocol {
    var listings = [NSManagedObject]()
    var selectedFavorite : NSManagedObject? = nil
    var collectionDataSource = CollectionViewDataSource()
    var collectionDelegate = CollectionViewDelegate()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Housing")
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            listings = results as! [NSManagedObject]
            setCollection()
            self.collectionView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar(NSLocalizedString("Favoritos", comment: ""))
    }
    
    // Configures the cell, datasource and delegate of collection view
    func setCollection () {
        
        // Configures how each cell displays in the collection view
        let configureCell: CollectionViewCellConfigureBlock = {cell,listing in
            let info = listing as! NSManagedObject
            let cell = cell as! ListingCell
            cell.listingName.text = info.valueForKey("name") as? String
            cell.listingType.text = info.valueForKey("type") as? String
            cell.price.text = info.valueForKey("price") as? String
            
            // Sets image
            let imageData = info.valueForKey("image") as? NSData
            cell.listingImage.image = UIImage(data: imageData!)
            cell.likeButton.setImage(UIImage(named: "like-selected"), forState: .Normal)
            cell.buttonProtocol = self
        }
        
        // Sets the collectionview data source and delegate
        self.collectionDataSource = CollectionViewDataSource(anItems: listings, cellIdentifier: "listingCell", aconfigureCellBlocks: configureCell)
        self.collectionDelegate.didSelectBlock = {indexPath in self.didSelect(indexPath)}
        self.collectionView.dataSource = self.collectionDataSource
        self.collectionView.delegate = self.collectionDelegate

    }
    
    // Use to set the collection view's delegate DidSelectItem method
    func didSelect (indexPath : NSIndexPath) {
        selectedFavorite = listings[indexPath.row]
        self.performSegueWithIdentifier("detail", sender: self)
    }
    
    // Set the detail's view listing information
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            let nextController = segue.destinationViewController as! DetailView
            nextController.currentFavorite = selectedFavorite
            nextController.fromFavorites = true
        }
    }
    
    // Saves or removes a favorite
    func saveFavorite(cell: ListingCell) {
        let indexPath = self.collectionView.indexPathForCell(cell)
        let info = self.listings[indexPath!.row]
        let id = info.valueForKey("id") as! String
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Housing")
        request.returnsObjectsAsFaults = false;
        
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
            // If there's an error saving the deletion
            } catch let error as NSError {
                print("Could not save  \(error), \(error.userInfo)")
            }
            
        // If there's an error fetching the listing to delete
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }


}
