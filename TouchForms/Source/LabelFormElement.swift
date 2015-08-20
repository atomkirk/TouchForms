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

    public var font: UIFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)

    public init(text: String) {
        self.text = text
    }

    public override func calculatedSizeForWidth(width: CGFloat) -> CGSize {
        return text.sizeWithWidth(width, font: font)
    }

    public override func populateCell() {
        if let cell = cell as? LabelFormCell {
            cell.textLabel?.text = text
            cell.textLabel?.font = font
        }
        super.populateCell()
    }

}
