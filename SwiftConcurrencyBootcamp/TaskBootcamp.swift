//
//  TaskBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Andres camilo Raigoza misas on 12/05/22.
//

import SwiftUI

extension TaskBootcamp {
    class ViewModel: ObservableObject {
        @Published var image: UIImage?
        @Published var image2: UIImage?
        
        func fetchImage() async {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            
            do {
                // It's good check for cancellation sometimes, because it's possible that you already canceled the task but regardless your code continues working, so if we cath this error then we can stop our code right away if needed.
                try Task.checkCancellation()
            } catch {
                
            }
            
            do {
                guard let url = URL(string: "https://picsum.photos/1000") else { return }
                let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
                await MainActor.run {
                    self.image = UIImage(data: data)
                    print("Image returned successfully!")
                }
            } catch {
                
            }
        }
        
        func fetchImage2() async {
            do {
                guard let url = URL(string: "https://picsum.photos/1000") else { return }
                let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
                await MainActor.run {
                    self.image2 = UIImage(data: data)
                }
            } catch {
                
            }
        }
    }
}

struct TaskBootcampHomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("CLICK ME! 🤓") {
                    TaskBootcamp()
                }
            }
        }
    }
}

struct TaskBootcamp: View {
    @StateObject private var vm = ViewModel()
    //@State private var fetchImageTask: Task<(), Never>?
    
    var body: some View {
        VStack(spacing: 40) {
            if let uiImage = vm.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let uiImage = vm.image2 {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            // This task gets canceled automatically on disappear
            await vm.fetchImage()
        }
//        .task {
//            print(Thread.current)
//            print(Task.currentPriority)
//            await vm.fetchImage2()
//        }
        .onDisappear {
            //fetchImageTask?.cancel()
        }
        .onAppear {
//            fetchImageTask = Task {
//                await vm.fetchImage()
//            }
//            Task(priority: .high) {
//                //try? await Task.sleep(nanoseconds: 2_000_000_000)
//                await Task.yield()
//                print("HIGH : \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .userInitiated) {
//                print("USER INITIATED : \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .medium) {
//                print("MEDIUM : \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .low) {
//                print("LOW : \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .utility) {
//                print("UTILITY : \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .background) {
//                print("BACKGROUND : \(Thread.current) : \(Task.currentPriority)")
//            }
            
//            Task(priority: .userInitiated) {
//                print("USER INITIATED : \(Thread.current) : \(Task.currentPriority)")
//
//                // Child tasks will inherit the metadata from its parent if we don't especify a priority for the child or if we don't detach it. It's better never to use detached if possible.
//                Task.detached {
//                    print("Detached : \(Thread.current) : \(Task.currentPriority)")
//                }
//            }
        }
    }
}

struct TaskBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TaskBootcamp()
    }
}
