//: Playground - noun: a place where people can play

//import TouchForms

//import Foundation
//
//protocol P {
//    typealias SomeType
//    func delegateImplementation(a: SomeType)
//}
//
//class A<T: NSObject>: P {
//    typealias SomeType = A<T>
//    func blah(e: T) {
//        println(e.dynamicType)
//    }
//    func delegateImplementation(a: SomeType) {
//
//    }
//}
//
//class B<T: NSObject>: A<T> {
//    typealias SomeType = B<T>
//    override func blah(e: T) {
//        println(e.dynamicType)
//    }
//    override func delegateImplementation(a: SomeType) {
//        
//    }
//}
//
//let b = B()
//b.blah("")
//b.delegateImplementation(b)