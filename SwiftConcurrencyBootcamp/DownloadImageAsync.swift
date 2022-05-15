//
//  DownloadImageAsync.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Andres camilo Raigoza misas on 28/04/22.
//

import SwiftUI
import Combine

extension DownloadImageAsync {
    class ImageLoader {
        let url = URL(string: "https://picsum.photos/200")!
        
        func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
            guard
                let data = data,
                let image = UIImage(data: data),
                let response = response as? HTTPURLResponse,
                200...299 ~= response.statusCode
            else {
                return nil
            }
            return image
        }
        
        func downloadWithEscaping(completion: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                let image = self?.handleResponse(data: data, response: response)
                completion(image, error)
            }
            .resume()
        }
        
        func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
            URLSession.shared.dataTaskPublisher(for: url)
                .map(handleResponse)
                .mapError({ $0 })
                .eraseToAnyPublisher()
        }
        
        func downloadWithAsync() async throws -> UIImage? {
            let (data, response) = try await URLSession.shared.data(from: url)
            return handleResponse(data: data, response: response)
        }
    }
}

extension DownloadImageAsync {
    class ViewModel: ObservableObject {
        @Published var image: UIImage?
        let loader = ImageLoader()
        var cancellables = Set<AnyCancellable>()
        
        func fetchImage() async {
            // With Escaping closure
            /*
            loader.downloadWithEscaping { [weak self] image, error in
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
             */
            
            // With Combine
            /*
            loader.downloadWithCombine()
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    
                } receiveValue: { [weak self] image in
                    self?.image = image
                }
                .store(in: &cancellables)
             */
            
            // With Async Await
            let image = try? await loader.downloadWithAsync()
            await MainActor.run {
                self.image = image
            }
        }
    }
}

struct DownloadImageAsync: View {
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
        //.onAppear(perform: vm.fetchImage)
        .task {
            await vm.fetchImage()
        }
    }
}

struct DownloadImageAsync_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImageAsync()
    }
}
