//
//  StoryboardPrototypeCellsForm.swift
//  Example
//
//  Created by Adam Kirk on 8/24/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit
import TouchForms

class StoryboardPrototypeCellsForm: FormController {
    
    override func configureForm() {
        
        // Text Field
        let textFieldElement = TextFieldFormElement(label: "Hello")
        textFieldElement.prototypeCellIdentifier = "textFieldCell"
        addFormElement(textFieldElement)
        
        // Label and Button
        let buttonInLabelElement = LabelAndButtonFormElement(label: "", buttonTitle: "") {
            print("button was tapped")
        }
        buttonInLabelElement.prototypeCellIdentifier = "buttonInLabel"
        addFormElement(buttonInLabelElement)
    }
    
}
