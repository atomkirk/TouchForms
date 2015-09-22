//
//  SignUpForm.swift
//  Example
//
//  Created by Adam Kirk on 8/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit
import TouchForms

class SignUpForm: FormController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = ExampleUser()
    }
    
    override func configureForm() {
        
        // HEADER
        let labelElement = LabelFormElement(text: "Sign Up")
        addFormElement(labelElement)
        
        // FOOTNOTE
        let footnoteElement = LabelFormElement(text: "Example of a subclassed form view controller where a blank model is created in its viewDidLoad.")
        footnoteElement.configureCellBlock { (cell) -> Void in
            if let cell = cell as? LabelFormCell {
                cell.formLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
            }
        }
        addFormElement(footnoteElement)
        
        // FIRST NAME
        let firstNameElement = TextFieldFormElement(label: "First Name")
        firstNameElement.modelKeyPath = "firstName"
        addFormElement(firstNameElement)
        
        // LAST NAME
        let lastNameElement = TextFieldFormElement(label: "Last Name")
        lastNameElement.modelKeyPath = "lastName"
        addFormElement(lastNameElement)
        
        // EMAIL
        let emailElement = TextFieldFormElement(label: "Email")
        emailElement.modelKeyPath = "email"
        emailElement.configureCellBlock { cell in
            if let cell = cell as? TextFieldFormCell {
                cell.formTextField?.keyboardType = .EmailAddress
            }
        }
        addFormElement(emailElement)
        
        // PASSWoRD
        let passwordElement = TextFieldFormElement(label: "Password")
        passwordElement.modelKeyPath = "password"
        passwordElement.configureCellBlock { cell in
            if let cell = cell as? TextFieldFormCell {
                cell.formTextField?.secureTextEntry = true
            }
        }
        addFormElement(passwordElement)
        
        // PRINT MODEL
        let printButtonElement = ButtonFormElement(label: "Log Current Model") {
            print("\(self.model)")
        }
        addFormElement(printButtonElement)
        
        // SET RANDOM VAlUES
        let setValuesButtonElement = ButtonFormElement(label: "Set Random Data on Model") {
            if let user = self.model as? ExampleUser {
                user.firstName  = randomStringWithLength(10)
                user.lastName   = randomStringWithLength(10)
                user.email      = randomStringWithLength(10)
                user.password   = randomStringWithLength(10)
            }
        }
        addFormElement(setValuesButtonElement)
        
    }
    
}


private let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" as NSString

private func randomStringWithLength(length: Int) -> String {
    var randomString = ""
    for _ in 0..<length {
        let range = NSMakeRange(Int(arc4random()) % letters.length, 1)
        let character = letters.substringWithRange(range)
        randomString.append(Character(character))
    }
    return randomString
}
