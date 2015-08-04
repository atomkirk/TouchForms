//
//  StringFromURLValueTransformer.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/29/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

public enum ImageFromDataValueTransformerReverseImageType {
    case JPEG
    case PNG
}

public class ImageFromDataValueTransformer: NSValueTransformer {

    let reverseTransformImageType: ImageFromDataValueTransformerReverseImageType

    public init(reverseTransformImageType: ImageFromDataValueTransformerReverseImageType) {
        self.reverseTransformImageType = reverseTransformImageType
    }

    public override class func transformedValueClass() -> AnyClass {
        return UIImage.self
    }

    public override class func allowsReverseTransformation() -> Bool {
        return true
    }

    public override func transformedValue(value: AnyObject?) -> AnyObject? {
        if let data = value as? NSData {
            return UIImage(data: data)
        }
        return nil
    }

    public override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        if let image = value as? UIImage {
            if reverseTransformImageType == .PNG {
                return UIImagePNGRepresentation(image)
            }
            else if reverseTransformImageType == .JPEG {
                return UIImageJPEGRepresentation(image, 1.0)
            }
        }
        return nil
    }

}