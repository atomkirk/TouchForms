//
//  RegexFormValidator.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

/**
Some common patterns you can use for `matchPattern`.
*/
let RegexFormValidatorPatternEmail     = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$"
let RegexFormValidatorPatternUsername  = "^[a-z0-9_-]{3,16}$"
let RegexFormValidatorPatternPassword  = "^[a-z0-9_-]{6,18}$"
let RegexFormValidatorPatternHex       = "^#?([a-f0-9]{6}|[a-f0-9]{3})$"
let RegexFormValidatorPatternSlug      = "^[a-z0-9-]+$"
let RegexFormValidatorPatternURL       = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
let RegexFormValidatorPatternIPAddress = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

public struct RegexFormValidator: FormValidatorType {

    /**
    If YES, a nil value will reported as valid. No match will be attempted. Default is NO.
    */
    public var nilAllowed = false

    /**
    If YES, a nil value or an empty string will be reported as valid. Default is NO.
    */
    public var blankAllowed = false

    /**
    You can provide a simple string pattern and we'll create an NSRegularExpression with sane options for you. It will be stored in
    `matchExpression`.
    */
    public var matchPattern: String {
        didSet {
            var error: NSError?
            let options = NSRegularExpressionOptions( NSRegularExpressionOptions.CaseInsensitive.rawValue | NSRegularExpressionOptions.DotMatchesLineSeparators.rawValue)
            if let regex = NSRegularExpression(pattern: matchPattern, options: options, error: &error) {
                matchExpression = regex
                if let string = userFriendlyFailureStringFromPattern(matchPattern) {
                    failedString = string
                }
            }
        }
    }

    /**
    For more control, you can create and provide the whole expression object yourself.
    */
    public var matchExpression: NSRegularExpression? {
        didSet {
            if let regex = matchExpression,
                let string = userFriendlyFailureStringFromPattern(regex.pattern) {
                    failedString = string
            }
        }
    }


    // MARK: - FormValidatorType

    public var failedString: String = "Invalid Format"

    public func errorFromValidatingValue(value: AnyObject?) -> NSError? {
        if value != nil {
            if nilAllowed {
                return nil
            }
            else {
                return errorWithString(failedString)
            }
        }

        if let string = value as? String {
            if count(string) == 0 {
                if blankAllowed {
                    return nil
                }
                else {
                    return errorWithString(failedString)
                }
            }

            if let regex = matchExpression
                where regex.numberOfMatchesInString(string, options: nil, range: NSMakeRange(0, count(string))) > 0 {
                    return nil
            }
            else {
                return errorWithString(failedString)
            }
        }

        return errorWithString("Value was not a string")
    }


    // MARK: - Public

    /**
    A convenience constructor that uses the same rules as setting `matchPattern`.
    */
    init(pattern: String, failedString: String) {
        matchPattern = pattern
        self.failedString = failedString
    }

    /**
    Convenient constructor for using `MYSFormValidationPattern…` constants that define a pattern and sane failureString.
    */
    init(patternName: String) {
        matchPattern = patternName
        if let suggestedFailString = userFriendlyFailureStringFromPattern(matchPattern) {
            failedString = suggestedFailString
        }
    }

    // MARK: - Private

    private func userFriendlyFailureStringFromPattern(pattern: String) -> String? {
        if matchPattern == RegexFormValidatorPatternEmail {
            return "Must be a valid E-mail."
        }
        return nil
    }

    private func errorWithString(string: String) -> NSError {
        return NSError(domain: FormErrorDomain, code: 1, userInfo: [
            NSLocalizedDescriptionKey: string,
            NSLocalizedFailureReasonErrorKey: string
            ])
    }

}