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

    public let font: UIFont

    public init(text: String, font: UIFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)) {
        self.text = text
        self.font = font
    }


    // MARK: - Overrides

    public override func populateCell() {
        if let cell = cell as? LabelFormCell,
            let label = cell.textLabel {
                label.text = text
                label.font = font
        }
    }

}
