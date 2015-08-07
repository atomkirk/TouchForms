//
//  ViewChildFormElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/24/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

class ViewChildFormElement: ChildFormElement {

    let view: UIView

    init(view: UIView, parentElement: FormElement) {
        self.view = view
        super.init(parentElement: parentElement, type: .View, position: .Below)
    }

}
