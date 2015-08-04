//
//  TextFieldFormCell.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit

public class TextFieldFormCell: FormCell, UITextFieldDelegate {

    @IBOutlet public weak var textField: UITextField!

    public override func awakeFromNib() {
        super.awakeFromNib()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidChange:", name: UITextFieldTextDidChangeNotification, object: textField)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }


    // MARK: - FormCell

    public override var valueKeyPath: String? {
        return "textField.text"
    }


    // MARK: - DELEGATE text field

    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        NSNotificationCenter.defaultCenter().postNotificationName(TextFieldFormCellDidHitReturnKeyNotification, object: self)
        return true
    }


    // MARK: - Notifications

    func textFieldDidChange(note: NSNotification) {
        delegate?.formCell(self, valueDidChange: textField.text)
    }

}
