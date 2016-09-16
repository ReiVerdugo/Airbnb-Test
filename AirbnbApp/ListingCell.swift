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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.listingImage.image = nil
    }

}
