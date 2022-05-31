//
//  SendableBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Andres camilo Raigoza misas on 31/05/22.
//

import SwiftUI

actor CurrentUserManager {
    
    func updateDatabase(userInfo: MyClassUserInfo) {
        
    }
}

struct MyUserInfo: Sendable {
    let name: String
}

final class MyClassUserInfo: @unchecked Sendable {
    private var name: String
    let queue = DispatchQueue(label: "com.MyApp.MyClassUserInfo")
    
    init(name: String) {
        self.name = name
    }
    
    func updateName(name: String) {
        queue.async {
            self.name = name
        }
    }
}

extension SendableBootcamp {
    class ViewModel: ObservableObject {
        let manager = CurrentUserManager()
        
        func updateCurrentUserInfo() async {
            let info = MyClassUserInfo(name: "User Info")
            await manager.updateDatabase(userInfo: info)
        }
    }
}

struct SendableBootcamp: View {
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        Text("Hello, World!")
            .task {
                
            }
    }
}

struct SendableBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        SendableBootcamp()
    }
}
