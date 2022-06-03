//
//  AsyncPublisherBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Andres camilo Raigoza misas on 2/06/22.
//

import SwiftUI

extension AsyncPublisherBootcamp {
    actor DataManager {
        @Published var myData = [String]()
        
        func addData() async {
            myData.append("Apple")
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            myData.append("Banana")
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            myData.append("Orange")
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            myData.append("Watermelon")
        }
    }
}

extension AsyncPublisherBootcamp {
    class ViewModel: ObservableObject {
        @MainActor @Published var dataArray = [String]()
        let manager = DataManager()
        
        init() {
            addSubscribers()
        }
        
        func addSubscribers() {
            // If we want multiple subscribers we will need to create multiple tasks insted of creating just one with many subscribers. If we have multiple subscribers inside one task then it will just going to execute the first one.
            Task {
                for await value in await manager.$myData.values {
                    await MainActor.run {
                        self.dataArray = value
                    }
                }
            }
//            Task {
//                for await value in await manager.$myData.values {
//                    await MainActor.run {
//                        self.dataArray = value
//                    }
//                }
//            }
        }
        
        func start() async {
            await manager.addData()
        }
    }
}

struct AsyncPublisherBootcamp: View {
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
            await vm.start()
        }
    }
}

struct AsyncPublisherBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncPublisherBootcamp()
    }
}
