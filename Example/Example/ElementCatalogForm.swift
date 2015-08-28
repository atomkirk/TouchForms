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

    override func viewDidLoad() {
        super.viewDidLoad()
        model = ExampleUser()
    }

    override func configureForm() {

        // label
        let labelElement = LabelFormElement(text: "Here is a label\nhlk\nklasd\nlkjad")
        addFormElement(labelElement)

        // Text Field
        let textFieldElement = TextFieldFormElement(label: "First Name")
        textFieldElement.modelKeyPath = "firstName"
        addFormElement(textFieldElement)

        // Text View
        let textViewElement = TextViewFormElement()
        textViewElement.modelKeyPath = "biography"
        addFormElement(textViewElement)

        // Button
        let buttonElement = ButtonFormElement(label: "Button") {
            println("button tapped")
        }
        addFormElement(buttonElement)

        // Picker
        let pickerElement = PickerFormElement(label: "Age", values: (0...120).map{ "\($0)" })
        pickerElement.modelKeyPath = "yearsOld"
        pickerElement.valueTransformer = StringFromNumberValueTransformer()
        addFormElement(pickerElement)

        // Buttons
        let button1Element = ButtonFormElement(label: "Button 1") {
            println("button1 tapped")
        }
        button1Element.minimumWidth = view.bounds.size.width / 2
        addFormElement(button1Element)
        
        let button2Element = ButtonFormElement(label: "Button 2") { () -> Void in
            println("button2 tapped")
        }
        button2Element.minimumWidth = view.bounds.size.width / 2
        addFormElement(button2Element)

        // Label and Button
        let labelAndButtonElement = LabelAndButtonFormElement(label: "A label", buttonTitle: "Button") {
            println("label and button tapped")
        }
        addFormElement(labelAndButtonElement)

        // Image Picker
        let imageElement = ImagePickerFormElement(label: "Pick a Photo")
        imageElement.modelKeyPath = "avatar"
        addFormElement(imageElement)
    }

}
