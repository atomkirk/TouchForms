//
//  TextFieldFormElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit


public class LabelAndButtonFormElement: FormElement {

    public let label: String

    public let buttonTitle: String

    public let action: FormButtonAction?

    public init(label: String, buttonTitle: String, _ action: FormButtonAction) {
        self.label = label
        self.buttonTitle = buttonTitle
        self.action = action
    }

    public override func populateCell() {
        if let cell = cell as? LabelAndButtonFormCell {
            cell.label?.text = label
            cell.button?.enabled = enabled
            cell.button?.setTitle(buttonTitle, forState: .Normal)
        }
        super.populateCell()
    }

    // MARK: - FormCell Delegate

    public override func formCell(cell: FormCell, userDidPerformInteraction interaction: FormCellUserInteraction, view: UIView) {
        action?()
    }

}
