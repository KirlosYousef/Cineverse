//
//  NetworkService.swift
//  MovieExplorer
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation
import Alamofire

/// Network service implementation for handling API calls
class NetworkService: NetworkServiceProtocol {
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey: String
    
    init() {
        // Get API key from configuration
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "xcconfig"),
              let config = NSDictionary(contentsOfFile: path),
              let apiKey = config["API_KEY"] as? String else {
            fatalError("API_KEY not found in Secrets.xcconfig")
        }
        self.apiKey = apiKey
    }
    
    func fetch<T: Codable>(from endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        let urlString = "\(baseURL)\(endpoint)?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        AF.request(url).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
} 