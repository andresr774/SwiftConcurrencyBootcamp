//
//  CheckedContinuationBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Andres camilo Raigoza misas on 20/05/22.
//

import SwiftUI

extension CheckedContinuationBootcamp {
    class NetworkManager {
        
        func getData(url: URL) async throws -> Data {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        }
        
        func getData2(url: URL) async throws -> Data {
            return try await withCheckedThrowingContinuation { continuation in
                URLSession.shared.dataTask(with: url) { data, response, error in
                    // We must resume the continuation exactly once.
                    if let data = data {
                        continuation.resume(returning: data)
                    } else if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(throwing: URLError(.badURL))
                    }
                }
                .resume()
            }
        }
        
        func getHeartImageFromDatabase(completion: @escaping (_ image: UIImage) -> ()) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                completion(UIImage(systemName: "heart.fill")!)
            }
        }
        
        func getHeartImageFromDatabase() async -> UIImage {
            await withCheckedContinuation { continuation in
                getHeartImageFromDatabase { image in
                    continuation.resume(returning: image)
                }
            }
        }
    }
}

extension CheckedContinuationBootcamp {
    class ViewModel: ObservableObject {
        
        @Published var image: UIImage?
        let networkManager = NetworkManager()
        
        func getImage() async {
            guard let url = URL(string: "https://picsum.photos/300") else { return }
            
            do {
                let data = try await networkManager.getData2(url: url)
                if let image = UIImage(data: data) {
                    await MainActor.run {
                        self.image = image
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        func getHeartImage() async {
            self.image = await networkManager.getHeartImageFromDatabase()
        }
    }
}

struct CheckedContinuationBootcamp: View {
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            //await vm.getImage()
            await vm.getHeartImage()
        }
    }
}

struct CheckedContinuationBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CheckedContinuationBootcamp()
    }
}