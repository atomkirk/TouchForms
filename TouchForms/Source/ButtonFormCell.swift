//
//  TextFieldFormCell.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit

public class ButtonFormCell: FormCell {
    
    public var enabled = false

    @IBOutlet weak var formButton: FormButton? {
        didSet {
            formButton?.addTarget(self, action: "buttonWasTapped:", forControlEvents: .TouchUpInside)
        }
    }

    // MARK: - Actions

    func buttonWasTapped(button: UIButton) {
        if let button = button as? FormButton {
            button.action()
        }
    }

}
