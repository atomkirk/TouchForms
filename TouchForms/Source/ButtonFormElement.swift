//
//  TextFieldFormElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit

public class ButtonFormElement: FormElement {
    
    public var label: String
    
    public var action: FormButtonAction

    public init(label: String, _ action: FormButtonAction) {
        self.label = label
        self.action = action
    }

    public override func populateCell() {
        if let cell = cell as? ButtonFormCell {
            cell.enabled = enabled
            cell.formButton?.setTitle(label, forState: .Normal)
            if let button = cell.formButton {
                button.action = self.action
            }
        }
        super.populateCell()
    }

}
