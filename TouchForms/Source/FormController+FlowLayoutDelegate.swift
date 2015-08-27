//
//  FormController+FlowLayoutDelegate.swift
//  TouchForms
//
//  Created by Adam Kirk on 8/27/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

extension FormController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let elementGroup = elements[indexPath.section].elementGroup
        let element = elementGroup[indexPath.row]
        let cellSize = cellManager.cellSizeForElement(element)
        return cellSize
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let element = elements[section]
        return element.margins
    }
    
}