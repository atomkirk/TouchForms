//
//  TextFieldFormCell.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit

public class ButtonFormCell: FormCell {

    var enabled = true

    var contentInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

    var buttonSpacing = CGFloat(8)

    var buttons = [FormButton]() {
        didSet {
            for button in oldValue {
                button.removeFromSuperview()
            }

            for button in buttons {
                addSubview(button)
                button.enabled = enabled
            }
            setNeedsDisplay()
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let totalButtonSpace = bounds.size.width - contentInsets.left - self.contentInsets.right
        let buttonWidth = ((totalButtonSpace - CGFloat(buttons.count - 1) * buttonSpacing) / CGFloat(self.buttons.count))
        for (index, button) in enumerate(buttons) {
            button.setTitleColor(tintColor, forState: .Normal)
            var frame = button.frame
            frame.size.width = buttonWidth
            frame.size.height = bounds.size.height - contentInsets.top - contentInsets.bottom
            frame.origin.x = contentInsets.left + (buttonWidth + buttonSpacing) * CGFloat(index)
            frame.origin.y = contentInsets.top
            button.frame = frame
        }
    }


    // MARK: - Actions

    func buttonWasTapped(button: UIButton) {
        if let button = button as? FormButton {
            button.action()
        }
    }

}
