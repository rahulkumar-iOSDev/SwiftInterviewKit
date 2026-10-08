
extension Array {
    // Returns elements that satisfy the given condition.
    func myFilter(_ condition: (Element) -> Bool) -> [Element] {
        var filteredArray: [Element] = []
        for element in self {
            if condition(element) {
                filteredArray.append(element)
            }
        }
        return filteredArray
    }

    // Transforms each element and returns a new array.
    func myMap<T>(_ operation: (Element) -> T) -> [T] {
        var finalArray: [T] = []
        for element in self {
            finalArray.append(operation(element))
        }
        return finalArray
    }

    // Transforms each element and removes nil results.
    func myCompactMap<T>(_ operation: (Element) -> T?) -> [T] {
        var finalArray: [T] = []
        for element in self {
            if let operatedElement = operation(element) {
                finalArray.append(operatedElement)
            }
        }
        return finalArray
    }

    // Sorts the original array in place.
    mutating func mySort(_ areInIncreasingOrder: (Element, Element) -> Bool) {
        for i in 0 ..< self.count {
            for j in (i+1) ..< self.count {
                if !areInIncreasingOrder(self[i], self[j]) {
                    swapAt(j, i)
                }
            }
        }
    }

    // Returns a sorted copy without modifying the original array.
    func mySorted(_ areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] {
        var sortedArray = self
        for i in 0 ..< sortedArray.count {
            for j in (i+1) ..< sortedArray.count {
                if !areInIncreasingOrder(sortedArray[i], sortedArray[j]) {
                    sortedArray.swapAt(j, i)
                }
            }
        }
        return sortedArray
    }

    // Combines all elements into a single result.
    func myReduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) -> Result) -> Result {
        var result = initialResult
        for element in self {
            result = nextPartialResult(result, element)
        }
        return result
    }
}

var intArray = [1, 2, 3, 4, 5, 6, 7, 8]

// Filter: keeps only elements that satisfy the condition.
let evenNumberArray = intArray.myFilter { $0 % 2 == 0 }
print("Even Number Array: \(evenNumberArray)")

// Map: transforms every element and keeps nil values.
let evenNumberMapArray = intArray.myMap { element -> Int? in
    if element % 2 == 0 {
        return element
    } else {
        return nil
    }
}
print("Map Result: \(evenNumberMapArray)")

// CompactMap: transforms every element and removes nil values.
let evenNumberCompactMapArray = intArray.myCompactMap { element -> Int? in
    if element % 2 == 0 {
        return element
    } else {
        return nil
    }
}
print("CompactMap Result: \(evenNumberCompactMapArray)")

// Sort: modifies the original array.
var unsortedArray = [3, 4, 4, 2, 7, 1]
unsortedArray.mySort { $0 < $1 }
print("Sorted Array using sort: \(unsortedArray)")

// Sorted: returns a new sorted array without modifying the original array.
var unsortedArray2 = [13, 14, 4, 12, 7, 1]
let sortedArray2 = unsortedArray2.mySorted { $0 < $1 }
print("Sorted Array using sorted: \(sortedArray2)")

// Reduce: combines all elements into a single value.
let sum = intArray.myReduce(0) { $0 + $1 }
print("Sum using reduce: \(sum)")
