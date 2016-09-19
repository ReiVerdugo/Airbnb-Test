//
//  CollectionViewDelegate.swift
//  AirbnbApp
//
//  Created by devstn5 on 2016-09-19.
//  Copyright © 2016 NextDots. All rights reserved.
//

import UIKit


typealias DidSelectCellBlock = (indexPath : NSIndexPath) -> Void

class CollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    var didSelectBlock : DidSelectCellBlock = {_ in }
    var width : CGFloat = 1.0
    var height : CGFloat = 0.5
    
    // Sets the layout of the collectionview items. Uses widht and height as parameters. Their values corresponds to device's orientation
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.bounds.size.width * width, collectionView.bounds.size.height * height)
    }
    
    // Uses the given closure to set the method when selecting an index path
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.didSelectBlock(indexPath: indexPath)
    }
}
