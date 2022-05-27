//
//  ActorsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Andres camilo Raigoza misas on 27/05/22.
//

import SwiftUI

class MyDataManager {
    static let instance = MyDataManager()
    private init() { }
    
    var data = [String]()
    private let lock = DispatchQueue(label: "com.MyApp.MyDataManager")
    
    func getRandomData(completion: @escaping (_ title: String?) -> ()) {
        lock.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            completion(self.data.randomElement())
        }
    }
}

actor MyActorDataManager {
    static let instance = MyActorDataManager()
    private init() { }
    
    var data = [String]()
    
    nonisolated let randomText = "asdlkfjdkdjf"
    
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return data.randomElement()
    }
    
    nonisolated func getSavedData() -> String {
        "New Data"
    }
}

struct HomeView: View {
    @State private var text = ""
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    let manager = MyActorDataManager.instance
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onAppear {
            let string = manager.getSavedData()
        }
        .onReceive(timer) { _ in
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        text = data
                    }
                }
            }
//            DispatchQueue.global(qos: .background).async {
//                manager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            text = data
//                        }
//                    }
//                }
//            }
        }
    }
}

struct BrowseView: View {
    @State private var text = ""
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    let manager = MyActorDataManager.instance
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        text = data
                    }
                }
            }
//            DispatchQueue.global(qos: .default).async {
//                manager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            text = data
//                        }
//                    }
//                }
//            }
        }
    }
}

struct ActorsBootcamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
        }
    }
}

struct ActorsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ActorsBootcamp()
    }
}
