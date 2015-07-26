//
//  FormButton.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/23/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit

public typealias FormButtonAction = (FormElement) -> Void

public enum FormButtonStyle {
    case None
    case Default
    case Bordered
    case Filled
}

public class FormButton: UIButton {

    public var action: FormButtonAction?

    public var style: FormButtonStyle = .None

}
