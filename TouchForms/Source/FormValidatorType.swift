//
//  FormValidator.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/22/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

public let FormErrorDomain = "FormErrorDomain"

public protocol FormValidatorType {

    var failedString: String { get set }

    func errorFromValidatingValue(value: AnyObject?) -> NSError?

}
