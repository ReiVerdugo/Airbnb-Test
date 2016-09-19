//
//  CollectionViewDataSource.swift
//  Akiztamed
//
//  Created by devstn5 on 2016-07-26.
//  Copyright © 2016 Solsteace. All rights reserved.
//

import UIKit

typealias CollectionViewCellConfigureBlock = (cell: AnyObject, item: AnyObject) -> Void

typealias DidSelectCellBlock = (indexPath : NSIndexPath) -> Void

class CollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var items = [AnyObject]()
    var cellIdentifier = ""
    var configureCellBlock: CollectionViewCellConfigureBlock = {_,_ in }
    var didSelectBlock : DidSelectCellBlock = {_ in }
    
    override init() {
        super.init()
    }
    
    
    init(anItems:Array<AnyObject>, cellIdentifier:String, aconfigureCellBlocks: (CollectionViewCellConfigureBlock)){
        
        self.items = anItems
        self.cellIdentifier = cellIdentifier
        self.configureCellBlock = aconfigureCellBlocks
    }
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> AnyObject{
        
        return items[indexPath.row]
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        let item = self.itemAtIndexPath(indexPath)
        self.configureCellBlock(cell: cell, item: item)
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height * 0.5)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.didSelectBlock(indexPath: indexPath)
    }
    

}