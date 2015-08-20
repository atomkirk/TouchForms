//
//  TextFieldFormElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit


public class TextFieldFormElement: FormElement {

    public var label: String

    public var font: UIFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)

    public init(label: String) {
        self.label = label
    }


    // MARK: - Overrides

    public override func calculatedSizeForWidth(width: CGFloat) -> CGSize {
        var size = label.sizeWithWidth(width, font: font)
        // add cell padding around text
        size.height += 7 * 2
        // adding top and bottom margins
        size.height += 8 * 2
        return size
    }

    public override func populateCell() {
        if let cell = cell as? TextFieldFormCell {
            cell.textField?.placeholder = label
        }
        super.populateCell()
    }

    public override func isEditable() -> Bool {
        return true
    }

    public override func beginEditing() {
        cell?.textInput?.becomeFirstResponder()
    }

}
