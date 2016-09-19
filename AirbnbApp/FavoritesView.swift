//
//  FavoritesView.swift
//  AirbnbApp
//
//  Created by devstn5 on 2016-09-19.
//  Copyright © 2016 NextDots. All rights reserved.
//

import UIKit
import CoreData

class FavoritesView: UIViewController {
    var listings = [NSManagedObject]()
    var selectedFavorite : NSManagedObject? = nil
    var collectionDataSource = CollectionViewDataSource()
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
        setNavBar(NSLocalizedString("Favoritos", comment: ""))
        
    }
    
    func setCollection () {
        let configureCell: CollectionViewCellConfigureBlock = {cell,listing in
            let info = listing as! NSManagedObject
            let cell = cell as! ListingCell
            cell.listingName.text = info.valueForKey("name") as? String
            cell.listingType.text = info.valueForKey("type") as? String
            cell.price.text = info.valueForKey("price") as? String
            let imageData = info.valueForKey("image") as? NSData
            cell.listingImage.image = UIImage(data: imageData!)
            cell.likeButton.setImage(UIImage(named: "like-selected"), forState: .Normal)
        }
        self.collectionDataSource = CollectionViewDataSource(anItems: listings, cellIdentifier: "listingCell", aconfigureCellBlocks: configureCell)
        self.collectionDataSource.didSelectBlock = {indexPath in self.didSelect(indexPath)}
        self.collectionView.dataSource = self.collectionDataSource
        self.collectionView.delegate = collectionDataSource

    }
    
    func didSelect (indexPath : NSIndexPath) {
        selectedFavorite = listings[indexPath.row]
        self.performSegueWithIdentifier("detail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            let nextController = segue.destinationViewController as! DetailView
            nextController.currentFavorite = selectedFavorite
            nextController.fromFavorites = true
        }
    }


}
