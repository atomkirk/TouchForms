//
//  CollectViewFormLayout.swift
//  TouchForms
//
//  Created by Adam Kirk on 8/28/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit

protocol CollectionViewDelegateFormLayout {
    func collectionViewItemSize(collectionView: UICollectionView, layout: CollectionViewFormLayout, indexPath: NSIndexPath) -> CGSize
    func collectionViewItemInsets(collectionView: UICollectionView, layout: CollectionViewFormLayout, indexPath: NSIndexPath) -> UIEdgeInsets
}

class CollectionViewFormLayout: UICollectionViewLayout {
    
    var formLayoutDelegate: CollectionViewDelegateFormLayout?
    
    var layoutAttributes = [UICollectionViewLayoutAttributes]()

    override func prepareLayout() {
        layoutAttributes = []
        var x = CGFloat(0)
        var y = CGFloat(0)
        let containerSize = collectionView!.bounds.size
        let numberOfSections = collectionView!.numberOfSections()
        var lastSize = CGSizeZero
        var lastInsets = UIEdgeInsetsZero
        for s in 0..<numberOfSections {
            let numberOfItems = collectionView!.numberOfItemsInSection(s)
            for i in 0..<numberOfItems {
                
                let ip = NSIndexPath(forItem: i, inSection: s)
                let size = formLayoutDelegate?.collectionViewItemSize(collectionView!, layout: self, indexPath: ip) ?? CGSize(width: 50, height: 50)
                let insets = formLayoutDelegate?.collectionViewItemInsets(collectionView!, layout: self, indexPath: ip) ?? UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
                
                if x == 0 {
                    x = insets.left
                }
                
                let overflows = x > insets.left && x + size.width > containerSize.width
                if overflows {
                    x = insets.left
                    y += lastInsets.bottom + lastSize.height + insets.top
                }
                
                let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: ip)
                attributes.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
                layoutAttributes.append(attributes)
                
                x += size.width + insets.right
                lastSize = size
            }
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        return layoutAttributes.reduce(CGRectZero) { CGRectUnion($0, $1.frame) }.size
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        return layoutAttributes.filter { CGRectIntersectsRect($0.frame, rect) }
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return layoutAttributes.filter { $0.indexPath == indexPath }.first
    }
    
}