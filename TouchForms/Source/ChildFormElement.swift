//
//  ChildFormElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/24/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

enum ChildFormElementType {
    case Loading
    case ValidationError
    case Error
    case Success
    case View
}

class ChildFormElement: FormElement {

    let parentElement: FormElement

    var position: FormElementRelativePosition

    let type: ChildFormElementType

    init(parentElement element: FormElement, type: ChildFormElementType, position: FormElementRelativePosition) {
        self.parentElement = element
        self.type = type
        self.position = position
        super.init()
    }
    
}
