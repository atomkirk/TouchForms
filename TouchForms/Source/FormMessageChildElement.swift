//
//  FormMessageChildElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/23/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

class FormMessageChildElement: FormChildElement {

    let message: String

    init(message: String, type: FormChildElementType, parentElement: FormElement) {
        self.message = message
        super.init(parentElement: parentElement, type: type, position: .Below)
    }

}