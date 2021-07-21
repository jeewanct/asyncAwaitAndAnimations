//
//  AsynAwaitTest.swift
//  AsyncAwait
//
//  Created by jeevan tiwari on 6/12/21.
//

import Foundation
import UIKit
import SwiftUI

class TestViewModel: ObservableObject{
    @Published var details: [Users]?
    func getDetails() async {
        let itemLoader = ItemLoader()
        let response: Result<[Users]?, ErrorModel> =  await itemLoader.test(from: "https://jsonplaceholder.typicode.com/todos/")
        switch response{
        case .success(let users):
            details = users
        case .failure(let failure):
            print(failure)
        }
        
    }
}

struct Users: Codable, Identifiable{
    var userId: CLong
    var id: CLong
    var title: String
    var completed: Bool
}

struct ItemLoader {
    var session = URLSession.shared
    func test<T: Decodable>(from urlString: String) async -> Result<T?, ErrorModel>{
        do{
            let url = URL(string: urlString)!
            var response: (Data, URLResponse) = (Data(), URLResponse())
            if #available(iOS 15.0, *) {
                response = try await URLSession.shared.data(from: url)
            } else {
                // Fallback on earlier versions
                
            }
            let jsonDecoder = JSONDecoder()
            let finalModel = try? jsonDecoder.decode(T.self, from: response.0)
            return .success(finalModel)
        }catch _{
            return .failure(ErrorModel())
        }
    }
}

struct ErrorModel: Error{
    
}

//extension URLSession {
//    func decode<T: Decodable>(
//        _ type: T.Type = T.self,
//        from url: URL,
//        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
//        dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .deferredToData,
//        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate
//    ) async throws  -> T {
//        let (data, _) = try await data(from: url)
//
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = keyDecodingStrategy
//        decoder.dataDecodingStrategy = dataDecodingStrategy
//        decoder.dateDecodingStrategy = dateDecodingStrategy
//
//        let decoded = try decoder.decode(T.self, from: data)
//        return decoded
//    }
//}
