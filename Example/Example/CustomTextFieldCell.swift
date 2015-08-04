//
//  File.swift
//  Example
//
//  Created by Adam Kirk on 7/30/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit
import TouchForms

class CustomTextFieldCell: TextFieldCell {

    @IBOutlet weak var trailingSpaceConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        animate()
    }

    private func animate() {
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.trailingSpaceConstraint.constant = 30
            self.layoutIfNeeded()
        }) { (finished) -> Void in
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.trailingSpaceConstraint.constant = 8
                self.layoutIfNeeded()
            }, completion: { (finished) -> Void in
                self.animate()
            })
        }
    }

}
