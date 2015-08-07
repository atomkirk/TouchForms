//
//  TextFieldFormElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit


public class ButtonFormElement: FormElement {

    public var buttons = [FormButton]()

    public init(buttons: [FormButton]) {
        self.buttons = buttons
    }

    // MARK: - Cell Delegate

    public override func formCell(cell: FormCell, userDidPerformInteraction interaction: FormCellUserInteraction, view: UIView) {
        if let button = view as? FormButton {
            button.action?(self)
        }
    }

}
