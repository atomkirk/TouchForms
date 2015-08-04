//
//  TextFieldElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit


public class TextFieldElement: FormElement, TextFieldCellDelegate {

    public typealias CellType = TextFieldCell

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

    public override var cell: FormCell? {
        didSet {
            if let cell = cell as? TextFieldCell {
                cell.textFieldDelegate = self
            }
        }
    }


    // MARK: - DELEGATE text field cell

    public func textFormCell(cell: TextFieldCell, textDidChange text: String) {
        delegate?.formElement(self, valueDidChange: text)
    }

}
