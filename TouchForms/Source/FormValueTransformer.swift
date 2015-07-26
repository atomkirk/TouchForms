//
//  FormValueTransformer.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/23/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

public typealias FormValueTransformerBlock = (AnyObject) -> AnyObject

public class FormValueTransformer: NSValueTransformer {

    private let forwardBlock: FormValueTransformerBlock

    private let reverseBlock: FormValueTransformerBlock

    init(forwardBlock: FormValueTransformerBlock, reverseBlock: FormValueTransformerBlock) {
        self.forwardBlock = forwardBlock
        self.reverseBlock = reverseBlock
    }


    // MARK: - NSValueTransformer

    public override class func allowsReverseTransformation() -> Bool {
        return true
    }

    public override class func transformedValueClass() -> AnyClass {
        return AnyObject.self
    }

    public override func transformedValue(value: AnyObject?) -> AnyObject? {
        if let value: AnyObject = value {
            return forwardBlock(value)
        }
        return nil
    }

    public override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        if let value: AnyObject = value {
            return reverseBlock(value)
        }
        return nil
    }

}