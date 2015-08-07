//
//  TextFieldFormElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit


public class TextViewFormElement: FormElement {

    public var font: UIFont?

    public var editable: Bool = true


    // MARK: - Overrides

    public override func populateCell() {
        if let cell = cell as? TextViewFormCell {
            cell.textView.font = font
            cell.textView.editable = editable
        }
    }

    public override func isEditable() -> Bool {
        return true
    }

    public override func beginEditing() {
        cell?.textInput?.becomeFirstResponder()
    }

}