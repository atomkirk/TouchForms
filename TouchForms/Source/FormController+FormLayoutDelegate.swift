//
//  FormController+FlowLayoutDelegate.swift
//  TouchForms
//
//  Created by Adam Kirk on 8/27/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

extension FormController: CollectionViewDelegateFormLayout {
    
    func collectionViewItemSize(collectionView: UICollectionView, layout: CollectionViewFormLayout, indexPath: NSIndexPath) -> CGSize {
        let elementGroup = elements[indexPath.section].elementGroup
        let element = elementGroup[indexPath.item]
        let cellSize = element.cell!.contentView.systemLayoutSizeFittingSize(CGSize(width: collectionView.bounds.size.width, height: 100000))
        return cellSize
    }
    
    func collectionViewItemInsets(collectionView: UICollectionView, layout: CollectionViewFormLayout, indexPath: NSIndexPath) -> UIEdgeInsets {
        let elementGroup = elements[indexPath.section].elementGroup
        let element = elementGroup[indexPath.item]
        return element.margins
    }
    
}