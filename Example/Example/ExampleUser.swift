//
//  ExampleUser.swift
//  Example
//
//  Created by Adam Kirk on 8/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

class ExampleUser: NSObject {
    
    dynamic var firstName: String?
    
    dynamic var lastName: String?
    
    dynamic var email: String?
    
    dynamic var password: String?
    
    dynamic var yearsOld: Int = 0
    
    dynamic var birthDate: NSDate?
    
    dynamic var isLegalAdult = true
    
    dynamic var biography: String?
    
    dynamic var tags = Set<String>()
    
    override var description: String {
        return  "\n\(firstName)" +
                "\n\(lastName)" +
                "\n\(email)" +
                "\n\(password)" +
                "\n\(yearsOld)" +
                "\n\(birthDate)" +
                "\n\(isLegalAdult)" +
                "\n\(biography)" +
                "\n\(tags)"
    }
    
}