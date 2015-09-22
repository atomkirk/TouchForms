//
//  FormButton.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/23/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit

public typealias FormButtonAction = () -> Void

public enum FormButtonStyle {
    case Default
    case Bordered
    case Filled
}

public class FormButton: UIButton {

    public let style: FormButtonStyle

    public var action: FormButtonAction

    public init(label: String, style: FormButtonStyle, _ action: FormButtonAction) {
        self.style = style
        self.action = action
        super.init(frame: CGRectZero)
        setTitle(label, forState: .Normal)
    }

    public required init?(coder aDecoder: NSCoder) {
        self.style = .Default
        self.action = {}
        super.init(coder: aDecoder)
    }

    public override func didMoveToWindow() {
        switch style {
        case .Default:
            layer.cornerRadius = 0
            layer.borderWidth = 0
            setTitleColor(tintColor, forState: .Normal)
            layer.borderColor = nil
            backgroundColor = nil
        case .Bordered:
            layer.cornerRadius = 5.0
            layer.borderWidth = 1.0
            setTitleColor(tintColor, forState: .Normal)
            layer.borderColor = tintColor?.CGColor
            backgroundColor = nil
        case .Filled:
            layer.cornerRadius = 5.0
            layer.borderWidth = 1.0
            setTitleColor(UIColor.whiteColor(), forState: .Normal)
            setTitleColor(tintColor, forState: .Highlighted)
            layer.borderColor = tintColor?.CGColor
            backgroundColor = tintColor
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        switch style {
        case .Default:
            titleLabel?.textColor = tintColor
        case .Bordered:
            titleLabel?.textColor = tintColor
        case .Filled:
            titleLabel?.textColor = UIColor.whiteColor()
        }
    }

}
