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
        model = NSMutableDictionary()
        model?.setObject("Blah\nBlah\nBlah\nBlah", forKey: "longtext")
    }

    override func configureForm() {

        // label
        let labelElement = LabelFormElement(text: "Here is a label\nhlk\nklasd\nlkjad")
        addFormElement(labelElement)

        // Text Field
        let textFieldElement = TextFieldFormElement(label: "Hello")
        addFormElement(textFieldElement)

        // Text View
        let textViewElement = TextViewFormElement()
        textViewElement.modelKeyPath = "longtext"
        addFormElement(textViewElement)

        // Button
        let button = FormButton(label: "Button", style: .Bordered) {
            println("button tapped")
        }
        let buttonElement = ButtonFormElement(buttons: [button])
        addFormElement(buttonElement)

        // Picker
        let pickerElement = PickerFormElement(label: "Select an animal", values: ["Cat", "Dog", "Bird"])
        pickerElement.modelKeyPath = "animalName"
        addFormElement(pickerElement)

        // Buttons
        let button1 = FormButton(label: "Button 1", style: .Filled) {
            println("button1 tapped")
        }
        let button2 = FormButton(label: "Button 2", style: .Filled) {
            println("button2 tapped")
        }
        let buttonsElement = ButtonFormElement(buttons: [button1, button2])
        addFormElement(buttonsElement)

        // Label and Button
        let labelAndButtonElement = LabelAndButtonFormElement(label: "A label", buttonTitle: "Button") {
            println("label and button tapped")
        }
        addFormElement(labelAndButtonElement)

        // Image Picker
        let imageElement = ImagePickerFormElement(label: "Pick a Photo")
        imageElement.modelKeyPath = "image"
        addFormElement(imageElement)
    }

}
