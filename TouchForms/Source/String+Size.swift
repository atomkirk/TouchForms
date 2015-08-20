//
//  String+Size.swift
//  TouchForms
//
//  Created by Adam Kirk on 8/12/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

extension String {

    func sizeWithWidth(width: CGFloat, font: UIFont) -> CGSize {
        var size = (self as NSString).boundingRectWithSize(CGSize(width: width, height: CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [ NSFontAttributeName: font ], context: nil).size
        size.width = width
        return size
    }
    
}
