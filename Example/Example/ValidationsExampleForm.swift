//
//  ValidationsExampleForm.swift
//  Example
//
//  Created by Adam Kirk on 8/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit
import TouchForms

class ValidationsExampleForm: FormController {

    override func viewDidLoad() {
        super.viewDidLoad()
        model = ExampleUser()
    }

    override func configureForm() {
        super.configureForm()

        // HEADLINE
        let headlineElement = LabelFormElement(text: "Edit User")
        headlineElement.configureCellBlock { (cell) -> Void in
            if let cell = cell as? LabelFormCell {
                cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            }
        }

        // FOOTNOTE
        let footnoteElement = LabelFormElement(text: "Example of a form that utilizes validations.")
        footnoteElement.configureCellBlock { (cell) -> Void in
            if let cell = cell as? LabelFormCell {
                cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
            }
        }

        // FIRST NAME FIELD
        let firstNameElement = TextFieldFormElement(label: "First Name")
        firstNameElement.modelKeyPath = "firstName"
        firstNameElement.addFormValidator(PresenceFormValidator())
        addFormElement(firstNameElement)

        // LAST NAME FIELD
        let lastNameElement = TextFieldFormElement(label: "Last Name")
        lastNameElement.modelKeyPath = "lastName"
        lastNameElement.addFormValidator(PresenceFormValidator())
        addFormElement(lastNameElement)

        // EMAIL FIELD
        let emailElement = TextFieldFormElement(label: "E-mail")
        emailElement.modelKeyPath = "email"
        emailElement.addFormValidator(PresenceFormValidator())
        emailElement.addFormValidator(RegexFormValidator(patternName: RegexFormValidatorPatternEmail))
        emailElement.configureCellBlock { (cell) -> Void in
            if let cell = cell as? TextFieldFormCell {
                cell.textField?.keyboardType = .EmailAddress
            }
        }
        addFormElement(emailElement)

        let submitButtonElement = ButtonFormElement(label: "Validate") {
            if self.validate() {
                println("Valid")
            }
            else {
                println("Not Valid")
            }
        }
        addFormElement(submitButtonElement)

    }

}
