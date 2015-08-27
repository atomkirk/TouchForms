//
//  FormController+CollectionViewDelegate.swift
//  TouchForms
//
//  Created by Adam Kirk on 8/27/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

extension FormController: UICollectionViewDelegate {
    
    public override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let elementGroup = elements[indexPath.section].elementGroup
        let element = elementGroup[indexPath.row]
        element.height = cell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
    }
    
    public override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section < elements.count,
            let cell = cell as? FormCell {
                let element = elements[indexPath.section]
                formElementsDelegate?.formController(self, willRemoveElement: element, cell: cell)
        }
    }
    
}