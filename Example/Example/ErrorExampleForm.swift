//
//  LoadingExampleForm.swift
//  Example
//
//  Created by Adam Kirk on 8/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit
import TouchForms

class ErrorExampleForm: FormController {

    var firstNameElement: FormElement!

    var errorButtonElement: FormElement!
    
    var showAllErrorsButtonElement: FormElement!

    override func configureForm() {
        super.configureForm()

        // HEADLINE
        let headlineElement = LabelFormElement(text: "Edit User")
        headlineElement.configureCellBlock { (cell) -> Void in
            if let cell = cell as? LabelFormCell {
                cell.formLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            }
        }

        // FOOTNOTE
        let footnoteElement = LabelFormElement(text: "Example of a form ")
        footnoteElement.configureCellBlock { (cell) -> Void in
            if let cell = cell as? LabelFormCell {
                cell.formLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
            }
        }

        // First Name Field
        firstNameElement = TextFieldFormElement(label: "First Name")
        addFormElement(firstNameElement)

        // Show Error
        errorButtonElement = ButtonFormElement(label: "Show Error") {
            self.showErrorMessage("An error message that shows for 4 seconds.", belowElement: self.errorButtonElement, duration: 4, completion: nil)
        }
        addFormElement(errorButtonElement)

        // Show Error Specific
        let specificErrorElement = ButtonFormElement(label: "Show Error Specific") {
            self.showErrorMessage("Error above a specific element for 3 seconds", belowElement: self.firstNameElement, duration: 3, completion: nil)
        }
        addFormElement(specificErrorElement)
        
        // Show All Errors
        showAllErrorsButtonElement = ButtonFormElement(label: "Show All Errors") {
            self.showErrorMessage("This error message will show for 5 seconds.", belowElement: self.showAllErrorsButtonElement, duration: 5, completion: nil)
            self.showErrorMessage("This error message will show for 3 seconds.", belowElement: self.errorButtonElement, duration: 3, completion: nil)
            self.showErrorMessage("This error message will show for 6 seconds.", belowElement: self.firstNameElement, duration: 6, completion: nil)
        }
        addFormElement(showAllErrorsButtonElement)

        // Hide Error Early
        let hideErrorEarlyElement = ButtonFormElement(label: "Hide Error Early") {
            self.hideErrorMessageBelowElement(self.firstNameElement, completion: nil)
        }
        addFormElement(hideErrorEarlyElement)
        
        // Show Success Message
        let showSuccessMessage = ButtonFormElement(label: "Show Success Message") {
            self.showSuccessMessage("A Success Message", belowElement: self.firstNameElement, duration: 5, completion: nil)
        }
        addFormElement(showSuccessMessage)

    }

}
