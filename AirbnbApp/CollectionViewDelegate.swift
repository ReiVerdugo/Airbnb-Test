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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.bounds.size.width * width, collectionView.bounds.size.height * height)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.didSelectBlock(indexPath: indexPath)
    }
}
