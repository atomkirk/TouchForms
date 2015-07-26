//
//  FormTextFieldElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit


public class FormTextFieldElement: FormElement, FormTextFieldCellDelegate {

    public var label: String?

    public init(label: String) {
        self.label = label
    }


    // MARK: - Overrides

    public override func isTextInput() -> Bool {
        return true
    }

    public override func isEditable() -> Bool {
        return true
    }

    public override func beginEditing() {
        cell?.textInput?.becomeFirstResponder()
    }

    public override var cell: FormCell? {
        didSet {
            if let cell = cell as? FormTextFieldCell {
                cell.textFieldDelegate = self
            }
        }
    }


    // MARK: - DELEGATE text field cell

    public func textFormCell(cell: FormTextFieldCell, textDidChange text: String) {
        delegate?.formElement(self, valueDidChange: text)
    }

}