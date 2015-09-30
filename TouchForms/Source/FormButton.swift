//
//  FormButton.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/23/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit

public typealias FormButtonAction = () -> Void

public class FormButton: UIButton {

    public var action: FormButtonAction
    
    public var label: String?

    public init(label: String, _ action: FormButtonAction) {
        self.action = action
        self.label = label
        super.init(frame: CGRectZero)
        setTitle(label, forState: .Normal)
    }

    public required init?(coder aDecoder: NSCoder) {
        self.action = {}
        super.init(coder: aDecoder)
    }

}
