//
//  ListingCell.swift
//  AirbnbApp
//
//  Created by Reinaldo Verdugo on 15/9/16.
//  Copyright © 2016 NextDots. All rights reserved.
//

import UIKit

/**
 A protocol implemented by *HomeViewController* and *FavoritesView* to implement a method to save housing as favorites by tapping the Like button.
 
- function saveFavorites: Saves to (or removes from) favorites.
 */
protocol SaveInFavoritesProtocol {
    func saveFavorite(cell: ListingCell)
}

class ListingCell: UICollectionViewCell {
    
    @IBOutlet weak var listingName: UILabel!
    @IBOutlet weak var listingType: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var listingImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    var likeSelected = false
    var buttonProtocol: SaveInFavoritesProtocol?
    
    /**
     Prepares the cell for reuse, sets the image to nil so that the image change is not so noticeable when scrolling
     */
    override func prepareForReuse() {
        super.prepareForReuse()
        self.listingImage.image = nil
        self.likeButton.imageView?.image = nil
    }
    
    /**
     When the user selects the LikeButton, call the protocol implemented at the *HomeViewController* or *FavoritesView* controller.
     */
    @IBAction func likeSelected(sender: UIButton) {
        if let favProtocol = buttonProtocol {
            favProtocol.saveFavorite(self)
        }
    }
    

}
