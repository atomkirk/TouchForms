//
//  StringFromURLValueTransformer.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/29/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

public class StringFromTimeZoneValueTransformer: NSValueTransformer {

    public override class func transformedValueClass() -> AnyClass {
        return NSString.self
    }

    public override class func allowsReverseTransformation() -> Bool {
        return true
    }

    public override func transformedValue(value: AnyObject?) -> AnyObject? {
        if let timezone = value as? NSTimeZone {
            return timezone.name
        }
        return nil
    }

    public override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        if let name = value as? String {
            return NSTimeZone(name: name)
        }
        return nil
    }
    
}
