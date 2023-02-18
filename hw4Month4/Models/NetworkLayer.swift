//
//  File.swift
//  hw4Month4
//
//  Created by Mac on 9/2/2023.
//

import Foundation


final class NetworkLayer {
    static let shared = NetworkLayer()
    
    private init() { }
    
    private var baseURL = URL(string: "https://dummyjson.com/products")!
    
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        let request = URLRequest(url: baseURL)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                let model: Products = self.decode(with: data)
                completion(.success(model.product))
            }
        }
        .resume()
    }
    
    func searchProducts(by word: String, completion: @escaping (Result<[Product], Error>) -> Void) {
        let url = baseURL.appendingPathComponent("search")
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [.init(name: "t", value: word)]
        if let url = urlComponents?.url {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = data {
                    let model: Products = self.decode(with: data)
                    completion(.success(model.product))
                }
            }
            .resume()
        }
    }
    
//https://dummyjson.com/posts/search?q=love
    
    func decode<T: Decodable>(with data: Data) -> T {
        try! JSONDecoder().decode(T.self, from: data)
    }
}








//final class NetworkLayer {
//    static let shared = NetworkLayer()
//
//    private init() { }
//
//    private var baseURL = URL(string: "https://i.dummyjson.com/data/products/24/1.jpg")!
//
////    func fetchProducts() throws -> [Product] {
////        let decoder = JSONDecoder()
////        let product = try decoder.decode([Product].self, from: Data(productJSON.utf8))
////        return product
////    }
//    func fetchCategory() throws -> [Category] {
//        let decode = JSONDecoder()
//        let category = try decode.decode([Category].self, from: Data(categoryJSON.utf8))
//        return category
//    }
//    func fetchOrderType() throws -> [TypeOfOrder] {
//        let decod = JSONDecoder()
//        let orderType = try decod.decode([TypeOfOrder].self, from: Data(orderTypeJSON.utf8))
//        return orderType
//    }
//
//    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
//        let request = URLRequest(url: baseURL)
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//            }
//
//            if let data = data {
//                let model: Products = self.decode(with: data)
//                completion(.success(model.product))
//            }
//        }
//        .resume()
//    }
//
//    func searchProducts(by word: String, completion: @escaping (Result<[Product], Error>) -> Void) {
//        let url = baseURL.appendingPathComponent("search")
//
//        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
//        urlComponents?.queryItems = [.init(name: "q", value: word)]
//        if let url = urlComponents?.url {
//            let request = URLRequest(url: url)
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    completion(.failure(error))
//                }
//
//                if let data = data {
//                  let model: Products = self.decode(with: data)
//                    completion(.success(model.product))
//                }
//            }
//            .resume()
//        }
//    }
//
////https://dummyjson.com/posts/search?q=love
//
//    func decode<T: Decodable>(with data: Data) -> T {
////
//        try! JSONDecoder().decode(T.self, from: data)
//
//    }
//}
//
//
