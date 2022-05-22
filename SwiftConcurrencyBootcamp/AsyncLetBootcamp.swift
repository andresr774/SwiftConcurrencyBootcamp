//
//  AsyncLetBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Andres camilo Raigoza misas on 15/05/22.
//

import SwiftUI

struct AsyncLetBootcamp: View {
    @State private var images: [UIImage] = []
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let url = URL(string: "https://picsum.photos/300")!
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Asyn Let 🥳")
            .onAppear {
                Task {
                    do {
                        async let fetchImage1 = fetchImage()
//                        async let fetchTitle = fetchTitle()
//
//                        let (image, title) = await (try fetchImage1, fetchTitle)
                        
                        async let fetchImage2 = fetchImage()
                        async let fetchImage3 = fetchImage()
                        async let fetchImage4 = fetchImage()
                        
                        // Here we are waiting to complete all 4 tasks and we are going to get the result just when all of the tasks are completed.
                        
                        // If we want to try to fetch an image and if it fails then continue with the next one we can use try?
                        
                        let (image1, image2, image3, image4) = await (try? fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
                    
                        images.append(contentsOf: [image1 ?? UIImage(), image2, image3, image4])
//                        let image1 = try await fetchImage()
//                        images.append(image1)
//
//                        let image2 = try await fetchImage()
//                        images.append(image2)
//
//                        let image3 = try await fetchImage()
//                        images.append(image3)
//
//                        let image4 = try await fetchImage()
//                        images.append(image4)
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func fetchTitle() async -> String {
        "New Title!"
    }
    
    func fetchImage() async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        if let image = UIImage(data: data) {
            return image
        } else {
            throw URLError(.badURL)
        }
    }
}

struct AsyncLetBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncLetBootcamp()
    }
}
