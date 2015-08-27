//
//  LoadingExampleForm.swift
//  Example
//
//  Created by Adam Kirk on 8/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit
import TouchForms

class LoadingExampleForm: FormController {

    var firstNameElement: FormElement!

    var loadButtonElement: FormElement!

    override func viewDidLoad() {
        super.viewDidLoad()
        model = ExampleUser()
    }

    override func configureForm() {
        super.configureForm()

        // HEADLINE
        let headlineElement = LabelFormElement(text: "Edit User")
//        headlineElement.configureCellBlock { (cell) -> Void in
//            if let cell = cell as? LabelFormCell {
//                cell.formLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
//            }
//        }

        // FOOTNOTE
        let footnoteElement = LabelFormElement(text: "Example of a form that utilizes validations.")
//        footnoteElement.configureCellBlock { (cell) -> Void in
//            if let cell = cell as? LabelFormCell {
//                cell.formLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
//            }
//        }

        // FIRST NAME FIELD
        firstNameElement = TextFieldFormElement(label: "First Name")
        firstNameElement.modelKeyPath = "firstName"
        addFormElement(firstNameElement)

        // LOADING
        loadButtonElement = ButtonFormElement(label: "Show Loading") { () -> Void in
            self.showLoadingMessage("This is a loading message added to Show Loading Button", aboveElement: self.loadButtonElement, completion: nil)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                self.hideLoadingAboveElement(self.loadButtonElement, completion: nil)
            })
        }
        addFormElement(loadButtonElement)

        // LOADING SPECIFIC
        let loadingSpecificElement = ButtonFormElement(label: "Show Loading Specific") { () -> Void in
            self.showLoadingMessage("Loading for a specific form element.", aboveElement: self.firstNameElement, completion: nil)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                self.hideLoadingAboveElement(self.firstNameElement, completion: nil)
            })
        }
        addFormElement(loadingSpecificElement)

        // LOADING HIDE SPECIFIC
        let loadingHideSpecific = ButtonFormElement(label: "Hide Loading Specific") { () -> Void in
            self.showLoadingMessage("This will show loading for 2 elements, stop one element after 4 seconds. And then all after 6 seconds.", aboveElement: self.loadButtonElement, completion: nil)
            self.showLoadingMessage("Here is the second loading message. This one will go first.", aboveElement: self.firstNameElement, completion: nil)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                self.hideLoadingAboveElement(self.firstNameElement, completion: nil)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                    self.hideLoadingAboveElement(self.loadButtonElement, completion: nil)
                })
            })
        }
        addFormElement(loadingHideSpecific)

    }

}
