//
//  ListingCell.swift
//  AirbnbApp
//
//  Created by Reinaldo Verdugo on 15/9/16.
//  Copyright © 2016 NextDots. All rights reserved.
//

import UIKit

class ListingCell: UICollectionViewCell {
    
    @IBOutlet weak var listingName: UILabel!
    @IBOutlet weak var listingType: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var listingImage: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    var likeSelected = false

    override func prepareForReuse() {
        super.prepareForReuse()
        self.listingImage.image = nil
        self.likeButton.imageView?.image = nil
    }
    
    @IBAction func likeSelected(sender: UIButton) {
        likeSelected = !likeSelected
        if likeSelected {
            likeButton.setImage(UIImage(named: "like-selected"), forState: .Normal)
        } else {
            likeButton.setImage(UIImage(named: "like"), forState: .Normal)
        }
    }
    

}
