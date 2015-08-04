//
//  TextFieldFormElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit


public class TextFieldFormElement: FormElement {

    public typealias CellType = TextFieldFormCell

    public var label: String?

    public init(label: String) {
        self.label = label
    }


    // MARK: - Overrides

    public override func populateCell() {
    }

    public override func isEditable() -> Bool {
        return true
    }

    public override func beginEditing() {
        cell?.textInput?.becomeFirstResponder()
    }

}
