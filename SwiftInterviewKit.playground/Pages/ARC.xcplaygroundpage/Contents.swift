//: [Previous](@previous)

import Foundation

struct Data  {
    var closure: (() -> Void)?
}

class Person {
    var completion: (() -> Void)?
    var data: Data? = Data()
    func setup() {
        completion = { [weak self] in
            self?.sayHello()
        }
        
        data?.closure = { [weak self] in
            print("Closure")
            self?.sayHello()
        }
    }
    
    func sayHello() {
        print("Hello")
    }
    
    deinit {
        print("Person deallocated")
    }
}

var person: Person? = Person()
person?.setup()
person = nil



