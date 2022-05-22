//
//  TaskGroupBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Andres camilo Raigoza misas on 15/05/22.
//

import SwiftUI

extension TaskGroupBootcamp {
    class DataManager {
        func fetchImagesWithAsyncLet() async throws -> [UIImage] {
            async let fetchImage1 = fetchImage(urlString: "https://picsum.photos/300")
            async let fetchImage2 = fetchImage(urlString: "https://picsum.photos/300")
            async let fetchImage3 = fetchImage(urlString: "https://picsum.photos/300")
            async let fetchImage4 = fetchImage(urlString: "https://picsum.photos/300")
            
            let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
            return [image1, image2, image3, image4]
        }
        
        func fetchImagesWithTaskGroup() async throws -> [UIImage] {
            let urlStrings = [
                "https://picsum.photos/300",
                "https://picsum.photos/300",
                "https://picsum.photos/300",
                "https://picsum.photos/300",
                "https://picsum.photos/300"
            ]
            // If we need to run tasks that doesn't throw errors we can use withThrowingTaskGroup insted
            return try await withThrowingTaskGroup(of: UIImage?.self) { group in
                var images: [UIImage] = []
                // In here we are telling the compiler the number of elements that the array is going to have, it's a performance boost.
                images.reserveCapacity(urlStrings.count)
                
                // When we create this child tasks, they are going to inherit the priority of their parent, in this case .task() from TaskGroupBootcamp View, that's why we don't need to provide a priority if we don't want to, but if we want to we can use addTask(priority: )
                for urlString in urlStrings {
                    group.addTask {
                        // We use try? here so that all tasks doesn't stop just if one of them fails.
                        try? await self.fetchImage(urlString: urlString)
                    }
                }
                for try await image in group {
                    // This results doesn't come in order, every time a result comes through it's going to do it inside this loop
                    // This loop doesn't behave like a normal loop, this loop it's going to wait for each task to come back
                    if let image = image {
                        images.append(image)
                    }
                }
                // After we got all the images, then return them.
                return images
            }
        }
        
        private func fetchImage(urlString: String) async throws -> UIImage {
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        }
    }
}

extension TaskGroupBootcamp {
    class ViewModel: ObservableObject {
        @Published var images: [UIImage] = []
        let manager = DataManager()
        
        func getImages() async {
            if let images = try? await manager.fetchImagesWithTaskGroup() {
                self.images.append(contentsOf: images)
            }
        }
    }
}

struct TaskGroupBootcamp: View {
    @StateObject private var vm = ViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(vm.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Task Group 🥳")
            .task {
                await vm.getImages()
            }
        }
    }
}

struct TaskGroupBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TaskGroupBootcamp()
    }
}
