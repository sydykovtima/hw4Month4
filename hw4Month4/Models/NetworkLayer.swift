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
    
    func fetchCategory() throws -> [Category] {
        let decode = JSONDecoder()
        let category = try decode.decode([Category].self, from: Data(categoryJSON.utf8))
        return category
    }
    
    func fetchOrderType() throws -> [TypeOfOrder] {
        let decod = JSONDecoder()
        let orderType = try decod.decode([TypeOfOrder].self, from: Data(orderTypeJSON.utf8))
        return orderType
    }
    
    func fetchProducts(completion: @escaping (Result<[Product], Error>)  -> Void) {
        let request = URLRequest(url: baseURL)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            
            if let data = data {
                do {
                    let model: Products = try self.decode(with: data)
                    completion(.success(model.products))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
    
    func searchProducts(
        by word: String,
        completion: @escaping (Result<[Product], Error>
        ) -> Void) {
        let url = baseURL.appendingPathComponent("search")
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [.init(name: "q", value: word)]
        if let url = urlComponents?.url {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = data {
                    do {
                        let model: Products = try self.decode(with: data)
                        completion(.success(model.products))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
            .resume()
        }
    }
    
    func decode<T: Decodable>(with data: Data) throws -> T {
        try JSONDecoder().decode(T.self, from: data)
    }
    
    private func initializeData<T: Encodable>(product: T) -> Data? {
        var encodedData: Data?
        encodeData(product: product) { result in
            switch result {
            case .success(let model):
                encodedData = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return encodedData
    }
    
    
    func encodeData<T: Encodable>(product: T, completion: @escaping (Result<Data, Error>) -> Void) {
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(product)
            completion(.success(encodedData))
        } catch {
            completion(.failure(error))
        }
    }
    
    func deleteProductsData(id: Int, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: baseURL.appendingPathComponent("\(id)"))
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Успешно удалено. \(httpResponse.statusCode)")
                    completion(.success(data!))
                }
            }
        }
        task.resume()
    }
    
    func postProductsData(model: Product, completion: @escaping (Result<Data, Error>) -> Void) {
        var encodedProductModel: Data?
        encodedProductModel = initializeData(product: encodedProductModel)
        guard encodedProductModel != nil else { return }
        
        var request = URLRequest(url: baseURL.appendingPathComponent("add"))
        request.httpMethod = "POST"
        request.httpBody = encodedProductModel
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                print("Успешно добавили новый продукт в POST-запросе. \(httpResponse.statusCode)")
                completion(.success(data!))
                }
            }
            guard let data = data else { return }
            completion(.success(data))
        }
        task.resume()
    }
}

