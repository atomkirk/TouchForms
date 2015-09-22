//
//  Stirng+StripModule.swift
//  TouchForms
//
//  Created by Adam Kirk on 8/27/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

extension String {
    
    func stripModule() -> String {
        if let index = self.characters.indexOf(".") {
            return self.substringFromIndex(index.successor())
        }
        return self
    }
    
}