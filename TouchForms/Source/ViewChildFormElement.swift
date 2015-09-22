//
//  ViewChildFormElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/24/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

class ViewChildFormElement: ChildFormElement {

    let view: UIView

    init(view: UIView, parentElement: FormElement) {
        self.view = view
        super.init(parentElement: parentElement, type: .View, position: .Below)
    }

    override func populateCell() {
        super.populateCell()
        if let contentView = cell?.contentView {
            for view in contentView.subviews {
                view.removeFromSuperview()
            }
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
            contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Top,      relatedBy: .Equal, toItem: view, attribute: .Top,      multiplier: 1, constant: 0))
            contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Bottom,   relatedBy: .Equal, toItem: view, attribute: .Bottom,   multiplier: 1, constant: 0))
            contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Leading,  relatedBy: .Equal, toItem: view, attribute: .Leading,  multiplier: 1, constant: 0))
            contentView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
        }
    }

}
