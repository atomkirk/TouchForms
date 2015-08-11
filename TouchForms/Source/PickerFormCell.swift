//
//  TextFieldFormCell.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit

public class PickerFormCell: FormCell {

    public var selectedValue: String?

    @IBOutlet public weak var button: FormButton?

    @IBOutlet public weak var label: UILabel?


    // MARK: - FormCell

    public override var valueKeyPath: String {
        return "selectedValue"
    }

    public override func modelValueDidChange() {
        button?.setTitle(selectedValue, forState: .Normal)
    }

    // MARK: - Actions

    @IBAction func buttonWasTapped(sender: UIView) {
        delegate?.formCell(self, userDidPerformInteraction: .Tap, view: sender)
    }

}
