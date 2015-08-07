//: Playground - noun: a place where people can play

//import TouchForms

import Foundation

class A<T: NSObject> {

    func blah(e: T) {
        println(e.dynamicType)
    }

}

class B<T: NSString>: A<T> {

    override func blah(e: T) {
        println(e.dynamicType)
    }

}

let b = B()
b.blah("")
