//
//  StyledFormButton.swift
//  TouchForms
//
//  Created by Adam Kirk on 9/29/15.
//  Copyright © 2015 Adam Kirk. All rights reserved.

import UIKit

public enum FormButtonStyle {
    case Default
    case Bordered
    case Filled
}

public class StyledFormButton: FormButton {
    
    public let style: FormButtonStyle
    
    public init(label: String, style: FormButtonStyle, _ action: FormButtonAction) {
        self.style = style
        super.init(label: label, action)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.style = .Default
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
