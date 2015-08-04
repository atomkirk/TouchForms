//
//  StringFromURLValueTransformer.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/29/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

public class StringFromNumberValueTransformer: NSValueTransformer {

    public override class func transformedValueClass() -> AnyClass {
        return NSString.self
    }

    public override class func allowsReverseTransformation() -> Bool {
        return true
    }

    public override func transformedValue(value: AnyObject?) -> AnyObject? {
        if let number = value as? NSNumber {
            return "\(number)"
        }
        return nil
    }

    public override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        if let numberString = value as? String {
            let floatValue = (numberString as NSString).floatValue
            return NSNumber(float: floatValue)
        }
        return nil
    }
    
}