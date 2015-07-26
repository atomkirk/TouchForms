//
//  BasicExampleForm.swift
//  Example
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit
import TouchForms

class BasicExampleForm: FormController {

    override func viewDidLoad() {
        super.viewDidLoad()
        model = NSMutableDictionary()
    }

    override func configureForm() {

        let firstElement = FormTextFieldElement(label: "Hello")
        addFormElement(firstElement)

    }
}
