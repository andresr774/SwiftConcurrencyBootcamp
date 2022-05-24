//
//  StructClassActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Andres camilo Raigoza misas on 22/05/22.
//

/*
 VALUE TYPES:
 - Struct, Enum, Struct, Int, etc.
 - Stored in the Stack
 - Faster
 - Thread Safe!
 - When you assign or pass value type a new copy of the data is created.
 
 REFERENCE TYPES:
 - Class, function, actor
 - Store in the heap
 - Slower, but synchronized
 - Not Thread safe (by default)
 - When you assign or pass reference type a new reference to original instance is created (pointer)
 
 ---------------------------------
 
 STACK:
 - Stores value types
 - Variable allocated on the stack are stored directly to the memory, and the access to this memory is very fast.
 - Each thread has its own stack!
 
 
 HEAP:
 - Stores Reference types
 - Shared accross threads
 
 ----------------------------------
 
 STRUCT:
 - Based on values
 - Can be mutated
 - Stored in the Stack!
 
 CLASS:
 - Based on REFERENCES (INSTANCES)
 - Stored in the Heap!
 - Inherit from other classes
 
 ACTOR:
 - Same as class but thread safe!
 
 ----------------------------------
 
 Structs: Data Models, Views
 Classes: ViewModels
 Actors: Shared 'Manager' and 'Data Store'
 
 */

import SwiftUI

extension StructClassActorBootcamp {
    actor DataManager {
        
    }
}

extension StructClassActorBootcamp {
    class ViewModel: ObservableObject {
        @Published var title = ""
        
        init() {
            print("ViewModel init")
        }
    }
}

struct StructClassActorBootcamp: View {
    @StateObject private var vm = ViewModel()
    let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
        print("View Init")
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(isActive ? .red : .blue)
            //.onAppear(perform: runTest)
    }
}

struct StructClassActorBootcampHomeView: View {
    @State private var isActive = false
    
    var body: some View {
        StructClassActorBootcamp(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
}

extension StructClassActorBootcamp {
    private func runTest() {
        print("Test Started!")
        structTest1()
        printDivider()
        classTest1()
        printDivider()
        actorTest1()
//        structTest2()
//        printDivider()
//        classTest2()
    }
    
    private func printDivider() {
        print("""
        
        --------------------------------------
        
        """)
    }
    
    private func structTest1() {
        print("structTest1")
        let objectA = MyStruct(title: "Starting Title!")
        print("ObjectA: ", objectA.title)
        
        print("Pass the Values of objectA to objectB.")
        var objectB = objectA
        print("ObjectB: ", objectB.title)
        
        objectB.title = "Second Title!"
        print("ObjectB title changed.")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
    }
    
    private func classTest1() {
        print("classTest1")
        let objectA = MyClass(title: "Starting Title!")
        print("ObjectA: ", objectA.title)
        
        print("Pass the REFERENCE of objectA to objectB.")
        let objectB = objectA
        print("ObjectB: ", objectB.title)
        
        objectB.title = "Second Title!"
        print("ObjectB title changed.")
        
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
    }
    
    private func actorTest1() {
        Task {
            print("actorTest1")
            let objectA = MyActor(title: "Starting Title!")
            await print("ObjectA: ", objectA.title)
            
            print("Pass the REFERENCE of objectA to objectB.")
            let objectB = objectA
            await print("ObjectB: ", objectB.title)
            
            await objectB.updateTitle("Second Title!")
            print("ObjectB title changed.")
            
            await print("ObjectA: ", objectA.title)
            await print("ObjectB: ", objectB.title)
        }
    }
}

struct MyStruct {
    var title: String
}

// Immutable struct
struct CustomStruct {
    let title: String
    
    func updateTitle(_ newTitle: String) -> CustomStruct {
        CustomStruct(title: newTitle)
    }
}

struct MutatingStruct {
    private(set) var title: String
    
    init(title: String) {
        self.title = title
    }
    
    mutating func updateTitle(_ newTitle: String) {
        title = newTitle
    }
}

extension StructClassActorBootcamp {
    
    private func structTest2() {
        print("structTest2")
        
        var struct1 = MyStruct(title: "Title1")
        print("Struct1: ", struct1.title)
        struct1.title = "Title2"
        print("Struct1: ", struct1.title)
        
        var struct2 = CustomStruct(title: "Title1")
        print("Struct2: ", struct2.title)
        struct2 = CustomStruct(title: "Title2")
        print("Struct2: ", struct2.title)
        
        var struct3 = CustomStruct(title: "Title1")
        print("Struct3: ", struct3.title)
        struct3 = struct3.updateTitle("Title2")
        print("Struct3: ", struct3.title)
        
        var struct4 = MutatingStruct(title: "Title1")
        print("Struct4: ", struct4.title)
        struct4.updateTitle("Title2")
        print("Struct4: ", struct4.title)
    }
}

class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(_ newTitle: String) {
        title = newTitle
    }
}

actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(_ newTitle: String) {
        title = newTitle
    }
}

extension StructClassActorBootcamp {
    
    private func classTest2() {
        print("classTest2")
        
        let class1 = MyClass(title: "Title1")
        print("Class1: ", class1.title)
        class1.title = "Title2"
        print("Class1: ", class1.title)
        
        let class2 = MyClass(title: "Title1")
        print("Class2: ", class2.title)
        class2.updateTitle("Title2")
        print("Class2: ", class2.title)

    }
}


