//
//  PresenceValidator.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

public struct PresenceValidator: FormValidatorType {

    public var failedString: String = "Can't be blank."

    public func errorFromValidatingValue(value: AnyObject?) -> NSError? {
        if value != nil {
            return nil
        }
        else {
            return NSError(domain: FormErrorDomain, code: 1, userInfo: [
                NSLocalizedDescriptionKey: failedString,
                NSLocalizedFailureReasonErrorKey: failedString
                ])
        }
    }

}