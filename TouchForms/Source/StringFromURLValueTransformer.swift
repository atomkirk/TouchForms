//
//  StringFromURLValueTransformer.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/29/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

public class StringFromURLValueTransformer: NSValueTransformer {

    public override class func transformedValueClass() -> AnyClass {
        return NSString.self
    }

    public override class func allowsReverseTransformation() -> Bool {
        return true
    }

    public override func transformedValue(value: AnyObject?) -> AnyObject? {
        if let url = value as? NSURL {
            return url.absoluteString
        }
        return nil
    }

    public override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        if var urlString = value as? String {
            if !urlString.hasPrefix("http") {
                urlString = "http://\(urlString)"
            }
            return NSURL(string: urlString)
        }
        return nil
    }
    
}