//
//  GlobalActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Andres camilo Raigoza misas on 27/05/22.
//

import SwiftUI

@globalActor final class MyFirstGlobalActor {
    static var shared = MyNewDataManager()
}

 actor MyNewDataManager {
    
    func getDataFromDatabase() -> [String] {
        ["One", "Two", "Three", "Four", "Five"]
    }
}

extension GlobalActorBootcamp {
    @MainActor class ViewModel: ObservableObject {
        
        @Published var dataArray = [String]()
        let manager = MyFirstGlobalActor.shared
        
        @MyFirstGlobalActor func getData() {
            Task {
                let data = await manager.getDataFromDatabase()
                await MainActor.run {
                    dataArray = data
                }
            }
        }
    }
}

struct GlobalActorBootcamp: View {
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await vm.getData()
        }
    }
}

struct GlobalActorBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        GlobalActorBootcamp()
    }
}
