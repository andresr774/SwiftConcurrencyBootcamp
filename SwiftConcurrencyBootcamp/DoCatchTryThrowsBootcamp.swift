//
//  DoCatchTryThrowsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Andres camilo Raigoza misas on 26/04/22.
//

import SwiftUI

extension DoCatchTryThrowsBootcamp {
    class DataManager {
        let isActive = true
        
        func getTitle() -> (title: String?, error: Error?) {
            if isActive {
                return ("New Text!", nil)
            } else {
                return (nil, URLError(.badURL))
            }
        }
        
        func getTitle2() -> Result<String, Error> {
            if isActive {
                return .success("New Text!")
            } else {
                return .failure(URLError(.appTransportSecurityRequiresSecureConnection))
            }
        }
        
        func getTitle3() throws -> String {
//            if isActive {
//                return "New Text!"
//            } else {
                throw URLError(.backgroundSessionWasDisconnected)
            //}
        }
        
        func getTitle4() throws -> String {
            if isActive {
                return "Final Text!"
            } else {
                throw URLError(.backgroundSessionWasDisconnected)
            }
        }
    }
}

extension DoCatchTryThrowsBootcamp {
    class ViewModel: ObservableObject {
        @Published var text = "Starting text"
        let manager = DataManager()
        
        func fetchTitle() {
            /*
            let returnedValue = manager.getTitle()
            
            if let newTitle = returnedValue.title {
                text = newTitle
            } else if let error = returnedValue.error {
                text = error.localizedDescription
            }
             */
            /*
            let result = manager.getTitle2()
            switch result {
            case .success(let newTitle):
                text = newTitle
            case .failure(let error):
                text = error.localizedDescription
            }
             */
            
//            if let newtitle = try? manager.getTitle3() {
//                text = newtitle
//            }
            
            do {
                let newTitle = try? manager.getTitle3()
                if let newTitle = newTitle {
                    text = newTitle
                }
                
                let finalTitle = try manager.getTitle4()
                text = finalTitle
            } catch {
                text = error.localizedDescription
            }
        }
    }
}

struct DoCatchTryThrowsBootcamp: View {
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        Text(vm.text)
            .frame(width: 300, height: 300)
            .background(.blue)
            .onTapGesture {
                vm.fetchTitle()
            }
    }
}

struct DoCatchTryThrowsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DoCatchTryThrowsBootcamp()
    }
}
