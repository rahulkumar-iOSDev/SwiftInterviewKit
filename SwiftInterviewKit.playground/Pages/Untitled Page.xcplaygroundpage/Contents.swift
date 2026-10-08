import UIKit

// MARK: -  Refernce Vs Value Type -
/*
struct ValueType {
    var number: Int
}

class ReferenceType {
    var number: Int
    
    init(number: Int) {
        self.number = number
    }
}

print("Value Type -----")

let a = ValueType(number: 10)
var b = a
b.number = 20

print(a.number)
print(b.number)

print("Reference Type -----")


let c = ReferenceType(number: 10)
let d = c
d.number = 20

print(c.number)
print(d.number)
*/

// MARK: - Generic -
/*
func sumOfNumber<T: Numeric>(a: T, b: T) -> T {
    return a + b
}

print(sumOfNumber(a: 10, b: 20))
 */

// MARK: - Property wrappper -
/*
@propertyWrapper
struct Capitalized {
    private var value: String

    init(wrappedValue: String) {
        self.value = wrappedValue.capitalized
    }

    var wrappedValue: String {
        get { value }
        set { value = newValue.capitalized }
    }
}

struct User {
    @Capitalized var name: String
}

var user = User(name: "john doe")
print(user.name)
*/

// MARK: -  Auto closures -
/*
func logIfTrue(_ condition: () -> Bool) {
    if condition() {
        print("Condition Met")
    }
}

logIfTrue ({ 5 > 3 })


func logAutoClosureIfTrue(_ condition: @autoclosure() -> Bool) {
    if condition() {
        print("Condition Met")
    }
}

logAutoClosureIfTrue(5>4)
 */

// MARK: -  ARC Deallocation -
/*
class Person {
    var name: String
    var pet: Pet?
    init(name: String) {
        self.name = name
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

class Pet {
    var name: String
    var person: Person?
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

var person: Person? = Person(name: "Reacher")
var pet: Pet?  = Pet(name: "Pauli")

person?.pet = pet
pet?.person = person
person = nil
pet = nil
 
*/
 
// MARK: -  Associated types -
/*
protocol Queue {
    associatedtype QueueType
    mutating func addElements(element: QueueType)
    func getElementsCount() -> Int
}

struct IntQueue: Queue {
    var array: [Int] = []
    mutating func addElements(element: Int) {
        array.append(element)
    }
    
    func getElementsCount() -> Int {
        array.count
    }
}

var intQueue = IntQueue()
intQueue.addElements(element: 5)
intQueue.addElements(element: 10)
intQueue.addElements(element: 20)
print("Total elements in Int Queue: \(intQueue.getElementsCount())")


struct FloatQueue: Queue {
    var array: [Float] = []
    mutating func addElements(element: Float) {
        array.append(element)
    }
    
    func getElementsCount() -> Int {
        array.count
    }
}

var floatQueue = FloatQueue()
floatQueue.addElements(element: 5)
floatQueue.addElements(element: 10)
print("Total elements in Float Queue: \(floatQueue.getElementsCount())")
 
 protocol Queue {
     associatedtype QueueType
     var array: Array<QueueType> { get }
     func addElements(elements: QueueType)
     func getNumberOfElements() -> Int
 }

 class IntQueue: Queue {
     var array: Array<Int> = []
     func addElements(elements: Int) {
         array.append(elements)
     }
     
     func getNumberOfElements() -> Int {
         array.count
     }
 }

 class floatQueue: Queue {
     var array: Array<Float> = []
     func addElements(elements: Float) {
         array.append(elements)
     }
     
     func getNumberOfElements() -> Int {
         array.count
     }
 }

 */

// MARK: - Remove Duplicate elements from an array using array with extension -
/*
let intArray: [Int] = [1, 3, 5, 5, 6, 1, 3, 3, 2, 11, 16, 1]
let stringArray: [String] = ["a", "c", "d", "e", "z", "a", "c", "e"]
extension Array where Element: Equatable {
    func removeDuplicateElements() -> Array? {
        guard !self.isEmpty else { return nil }
        var result = [Element]()
        self.forEach { element in
            if !result.contains(element) {
                result.append(element)
            }
        }
        return result
    }
}
print(intArray.removeDuplicateElements() ?? [])
print(stringArray.removeDuplicateElements() ?? [])
 */

// MARK: -  Get only Capital Character from String -
/*
func getOnlyCapitalLetters(_ input: String?) -> String {
    guard let input, !input.isEmpty else { return "" }
    let result = input.filter { ("A"..."Z").contains($0) }
    return result
}

print(getOnlyCapitalLetters("I am Genesis"))
print(getOnlyCapitalLetters("I am Macbook Pro"))
*/

// MARK: - Get only Int elements from Array of any type
/*
func getOnlyIntElements(_ input: [Any]) -> [Int] {
    let result = input.compactMap( { $0 as? Int } )
    return result
}
print(getOnlyIntElements([1, "c", "ghga", 5, 10]))
 */

// MARK: - Defer Statement -
/*
func underStandDeferStatement() -> String {
    print("Hi, I am first statement")
    defer {
        print("Hi, I am 1st defer statement")
    }
    print("Hi, I am middle statement")
    defer {
        print("Hi, I am 2nd defer statement")
    }
    defer {
        print("Hi, I am 3rd defer statement")
    }
    print("Hi, I am last statement")
    return "Hi I am return statement"
}
print(underStandDeferStatement())
*/

//MARK: - unowned -
/*
class Parent {
    var child: Child?
    init() {
        print("Parent init")
        child = Child(parent: self)
    }
    deinit {
        print("Parent deinit")
    }
}

class Child {
    weak var parent: Parent?

    init(parent: Parent) {
        self.parent = parent
        print("Child init")
    }
    deinit {
        print("Child deinit")
    }
}

var parent: Parent? = Parent()
var child: Child? = Child(parent: parent!)
parent?.child = child
child = nil
parent = nil
*/

// MARK: - Generics -
/*
func swapValues<T>(_ a: inout T, _ b: inout T) -> (T, T) {
    let temp = a
    a = b
    b = temp
    return (a, b)
}
var a = 4
var b = 5
print(swapValues(&a, &b))

class Container<T> {
    let value: T
    
    init(value: T) {
        self.value = value
    }
}
*/

// MARK: - Hashable protocol -
    /*
struct User: Hashable, Equatable {
    let id: Int
    let name: String
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
}


func printUser() {
    let users: Set<User> = [User(id: 1 , name: "JOHN"),
                        User(id: 1, name: "JOHN")]
    
    users.forEach { user in
        print(user.name)
    }
}


printUser()
     */

// MARK: - property Wrapper -
/*
struct User {
    @UpperCaseWrapper var name: String?
}

@propertyWrapper
struct UpperCaseWrapper {
    private var value: String?
    init(wrappedValue: String?) {
        self.value = wrappedValue?.uppercased()
    }
    var wrappedValue: String? {
        get {value}
        set {value = newValue?.uppercased()}
    }
}
var user = User(name: "john doe") // JOHN DOE
print(user.name)
*/


var username: String = "rahul" {
    willSet {
        print("Will selt: newValue \(newValue)")
    }

    didSet {
        print("Did se selt: old value \(oldValue)")
    }
}

username = "Rahul kumar"
print(username)
