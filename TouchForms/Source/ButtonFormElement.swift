//
//  TextFieldFormElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit


public class ButtonFormElement: FormElement {

    public var buttons: [FormButton] {
        didSet {
            if let cell = cell as? ButtonFormCell {
                cell.buttons = buttons
            }
        }
    }

    public init(buttons: [FormButton]) {
        self.buttons = buttons
    }

    public override func calculatedSizeForWidth(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 44 + 8 + 8)
    }

    public override func populateCell() {
        if let cell = cell as? ButtonFormCell {
            cell.buttons = buttons
            cell.enabled = enabled
        }
        super.populateCell()
    }

}
