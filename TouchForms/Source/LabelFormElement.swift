//
//  TextFieldFormElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit


public class LabelFormElement: FormElement {

    public let text: String

    public init(text: String) {
        self.text = text
    }

    public override func populateCell() {
        if let cell = cell as? LabelFormCell {
            cell.formLabel?.text = text
        }
        super.populateCell()
    }

}
