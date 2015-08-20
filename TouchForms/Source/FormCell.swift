//
//  FormCell.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/23/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

public enum FormCellUserInteraction {
    case Tap
    case LongPress
    case Swipe
}

public protocol FormCellDelegate {
    func formCell(cell: FormCell, valueDidChange value: AnyObject)
    func formCell(cell: FormCell, userDidPerformInteraction interaction: FormCellUserInteraction, view: UIView)
}

public class FormCell: UICollectionViewCell {

    // MARK: - Initializing

    /**
    Override in a subclass to do any initialization work.
    */
    public func commonInit() {

    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    // MARK: - UIView

    private var heightContstraint: NSLayoutConstraint?

    public override func layoutSubviews() {
        super.layoutSubviews()
        if heightContstraint == nil {
            heightContstraint = NSLayoutConstraint(item: self.contentView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: self.bounds.size.height)
            addConstraint(heightContstraint!)
            layoutIfNeeded()
        }
    }

    // MARK: - Subclassing

    /**
    The key path to the editable property on the view that is the primary editing
    control of this element. For example, for a text field element, the key path
    would be `textField.text`.
    */
    public var valueKeyPath: String? {
        return nil
    }

    /**
    If this cell has a text input element, override this method and return it.
    */
    public var textInput: UIView? {
        return nil
    }

    /**
    Override this to give yourself a chance to update the cell to display
    the current model value when it changes.
    */
    public func modelValueDidChange() {

    }


    // MARK: - Delegate

    public var delegate: FormCellDelegate?

}