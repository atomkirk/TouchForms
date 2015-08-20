//
//  TextFieldFormElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit


public class TextViewFormElement: FormElement {

    public var font: UIFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)

    public var editable: Bool = true


    // MARK: - Overrides

    public override func calculatedSizeForWidth(width: CGFloat) -> CGSize {
        let modelValue = (transformedModelValue() as? String) ?? "A"
        var size = modelValue.sizeWithWidth(width, font: font)
        // add cell padding around text
        size.height += 8 * 2
        // adding top and bottom margins
        size.height += 8 * 2
        return size
    }

    public override func populateCell() {
        if let cell = cell as? TextViewFormCell {
            cell.textView.font = font
            cell.textView.editable = editable
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
