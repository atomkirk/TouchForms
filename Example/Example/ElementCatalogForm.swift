//
//  ElementCatalogForm.swift
//  Example
//
//  Created by Adam Kirk on 8/5/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit
import TouchForms

class ElementCatalogForm: FormController {

    override func configureForm() {

        // label
        let labelElement = LabelFormElement(text: "Here is a label")
        addFormElement(labelElement)

        // Text Field
        let textFieldElement = TextFieldFormElement(label: "Hello")
        addFormElement(textFieldElement)

        // Text View
        let textViewElement = TextViewFormElement()
        addFormElement(textViewElement)

    }

}
