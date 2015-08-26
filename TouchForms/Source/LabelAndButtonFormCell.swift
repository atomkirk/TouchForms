//
//  TextFieldFormCell.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit

public class LabelAndButtonFormCell: FormCell {

    @IBOutlet weak var formLabel: UILabel?

    @IBOutlet weak var formButton: FormButton?

    public override func layoutSubviews() {
        super.layoutSubviews()
        formButton?.setTitleColor(tintColor, forState: .Normal)
    }

    // MARK: - Actions

    @IBAction func buttonWasTapped(button: FormButton) {
        delegate?.formCell(self, userDidPerformInteraction: .Tap, view: button)
    }

}
