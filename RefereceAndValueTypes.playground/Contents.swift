// MARK: VALUE TYPE
enum CompassPoint {
    case north, south, east, west
    
    mutating func turnNorth() {
        self = .north
    }
}

var currentDirection = CompassPoint.west

currentDirection = .east
currentDirection.turnNorth()

print(currentDirection)

// MARK: REFERENCE TYPE
class Person {
     var name: String
     init(name: String) {
          self.name = name
          print("\(name) is being initialized")
     }
     deinit {
         print("\(name) is being deinitialized")
     }
}
// STRONG REFERENCES
/*
var reference1: Person?
var reference2: Person?

reference1 = Person(name: "Jhon")
//reference2 = reference1

//reference1 = nil
//reference2 = nil // The reference count become 0

reference2 = Person(name: "Doyeon")

// Both gets initialized but not deinitialized because they are strong references, That means that these two objects just leaked.
reference1?.name = reference2!.name
reference2?.name = reference1!.name
 */

// WEAK REFERENCES
weak var reference1: Person?
var reference2: Person?

reference1 = Person(name: "Jhon")
reference2 = Person(name: "Doyeon")

reference1?.name = reference2!.name
reference2?.name = reference1!.name
