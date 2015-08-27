//
//  CellManager.swift
//  TouchForms
//
//  Created by Adam Kirk on 8/27/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit

class CellManager: NSObject, UICollectionViewDataSource {
    
    let collectionView: UICollectionView
    
    let factoryCollectionView: UICollectionView
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        // make a copy of the real collection view to act as our cell factory
        factoryCollectionView = NSKeyedUnarchiver.unarchiveObjectWithData(NSKeyedArchiver.archivedDataWithRootObject(collectionView)) as! UICollectionView
        
        super.init()
        
        // set data source to dummy data source
        factoryCollectionView.dataSource = self
        factoryCollectionView.delegate = nil
        
        // register metadata cells
        registerCellClassForReuse(MessageChildFormCell.self)
        registerCellClassForReuse(LoadingChildFormCell.self)
        
        // register view child cell
        let childViewClassName = NSStringFromClass(ViewChildFormCell.self).stripModule()
        collectionView.registerClass(ViewChildFormCell.self, forCellWithReuseIdentifier: childViewClassName)
        factoryCollectionView.registerClass(ViewChildFormCell.self, forCellWithReuseIdentifier: childViewClassName)
    }
    
    func registerCellForElement(element: FormElement) {
        if element.prototypeCellIdentifier == nil {
            registerCellClassForReuse(element.cellClass, xib: element.cellXib)
        }
    }
    
    func cellForElement(element: FormElement, indexPath: NSIndexPath) -> FormCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(element.cellReuseIdentifier, forIndexPath: indexPath) as! FormCell
        cell.contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        cell.contentView.addConstraint(NSLayoutConstraint(item: cell.contentView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: collectionView.bounds.size.width))
        element.cell = cell
        return cell
    }
    
    func cellSizeForElement(element: FormElement) -> CGSize {
        let cell = factoryCollectionView.dequeueReusableCellWithReuseIdentifier(element.cellReuseIdentifier, forIndexPath: NSIndexPath(forItem: 0, inSection: 0)) as! FormCell
        cell.contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        cell.contentView.addConstraint(NSLayoutConstraint(item: cell.contentView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: collectionView.bounds.size.width))
        element.cell = cell
        return cell.contentView.systemLayoutSizeFittingSize(CGSize(width: collectionView.bounds.size.width, height: 100000))
    }
    
}

// DataSource
extension CellManager {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 10000
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10000
    }
    
    // Not used, just satisfied protocol
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

}

// Helpers
extension CellManager {
    
    private func registerCellClassForReuse(cellClass: AnyClass, xib: String? = nil) {
        let nib = nibForCellClass(cellClass, xib: xib)
        let classString = NSStringFromClass(cellClass).stripModule()
        collectionView.registerNib(nib, forCellWithReuseIdentifier: classString)
        factoryCollectionView.registerNib(nib, forCellWithReuseIdentifier: classString)
    }
    
    private func nibForCellClass(cellClass: AnyClass, xib: String? = nil) -> UINib {
        let nib: UINib
        let classString = NSStringFromClass(cellClass).stripModule()
        if let xib = xib {
            let bundle = NSBundle(forClass: self.dynamicType)
            nib = UINib(nibName: xib, bundle: bundle)
        }
        else {
            let bundle = NSBundle(forClass: cellClass)
            nib = UINib(nibName: classString, bundle: bundle)
        }
        return nib
    }
    
}
