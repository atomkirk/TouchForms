//
//  FormTextFieldCell.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit

public protocol FormTextFieldCellDelegate: class {
    func textFormCell(cell: FormTextFieldCell, textDidChange text: String)
}

public class FormTextFieldCell: FormCell, UITextFieldDelegate {

    public weak var textFieldDelegate: FormTextFieldCellDelegate?

    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var textField: UITextField!

    public override func awakeFromNib() {
        super.awakeFromNib()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidChange:", name: UITextFieldTextDidChangeNotification, object: textField)
    }

    // MARK: - FormCell

    public override func valueForKey(key: String) -> AnyObject? {
        return "textField.text"
    }

    public override func populateWithElement(element: FormElement) {
        if let element = element as? FormTextFieldElement {
            label.text = element.label
            self.layoutIfNeeded()
        }
        super.populateWithElement(element)
    }


    // MARK: - DELEGATE text field

    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        NSNotificationCenter.defaultCenter().postNotificationName(FormTextFieldCellDidHitReturnKeyNotification, object: self)
        return true
    }


    // MARK: - Notifications

    func textFieldDidChange(note: NSNotification) {
        textFieldDelegate?.textFormCell(self, textDidChange: textField.text)
    }


}
