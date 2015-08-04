//
//  ThemedForm.swift
//  Example
//
//  Created by Adam Kirk on 7/29/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit
import TouchForms

class CustomThemeForm: FormController {

    override func configureForm() {

        /**
        Here we are just using a customized xib for the cell to customize the appearance.
        This is the easiest way to just change the way an existing element looks.
        */
        let textFieldElement = TextFieldElement(label: "Hello")
        textFieldElement.cellXib = "CustomXibTextField"
        addFormElement(textFieldElement)

        /**
        Here we are subclassing an existing element cell to customize appearance behavior.
        Customization is limited to things related to the appearnce of the cell, like animation
        and dynamic changes in positioning/color/etc.
        */
        let customTextFieldElement = TextFieldElement(label: "Custom")
        customTextFieldElement.cellClass = CustomTextFieldCell.self
        customTextFieldElement.configureCellBlock { cell in
            
        }
        addFormElement(customTextFieldElement)

        /**
        Here we are subclassing an existing element to use it's basic functionality and add
        some custom functionality. With this approach, the element will behave like it's superclass
        unless
        */

        /**
        Here we create an entirely new kind of element. We subclass FormElement, FormCell and create
        a xib for FormCell with the same name. This allows you to build any kind of custom input
        element and possibly create a value trans
        */
        let customElement = ProgressFormElement()
        customElement.progress = 0.75
        addFormElement(customElement)


    }

}