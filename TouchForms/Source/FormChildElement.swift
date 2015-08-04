//
//  FormChildElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/24/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

enum FormChildElementType {
    case Loading
    case ValidationError
    case Error
    case Success
    case View
}

class FormChildElement: FormElement {

    var parentElement: FormElement

    var position: FormElementRelativePosition

    let type: FormChildElementType

    init(parentElement element: FormElement, type: FormChildElementType, position: FormElementRelativePosition) {
        self.parentElement = element
        self.type = type
        self.position = position
        super.init()
    }
    
}
