//
//  NetworkService.swift
//  Cineverse
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation
import Alamofire

/// Network service implementation for handling API calls
class NetworkService: NetworkServiceProtocol {
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey: String
    
    /// Initializes the NetworkService and retrieves the API key from the app's configuration.
    init() {
        // Get API key from configuration
        guard let apiKey = Bundle.main.infoDictionary?["TMDBApiKey"] as? String else {
            fatalError("TMDBApiKey not found in Info.plist")
        }
        self.apiKey = apiKey
    }
    
    /// Fetches data from the specified endpoint and decodes it into the provided Codable type.
    ///
    /// - Parameters:
    ///   - endpoint: The API endpoint to fetch data from (e.g., "/movie/popular").
    ///   - parameters: Optional query parameters for the request (e.g., ["page": 2, "query": "batman"]).
    ///   - completion: Completion handler with a Result containing the decoded object or an error.
    func fetch<T: Codable>(from endpoint: String, parameters: [String: Any]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        // Check network connectivity first
        guard NetworkReachabilityManager.default?.isReachable == true else {
            completion(.failure(NetworkError.noConnection))
            return
        }
        
        var urlString = "\(baseURL)\(endpoint)?api_key=\(apiKey)"
        if let parameters = parameters {
            for (key, value) in parameters {
                let valueString = String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                urlString += "&\(key)=\(valueString)"
            }
        }
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        AF.request(url).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                print("data: \(data)")
                completion(.success(data))
            case .failure(let error):
                print("error: \(error)")
                // Check if it's a network connectivity error
                if let error = error as? AFError {
                    switch error {
                    case .sessionTaskFailed(let underlyingError):
                        if let urlError = underlyingError as? URLError {
                            switch urlError.code {
                            case .notConnectedToInternet, .networkConnectionLost:
                                completion(.failure(NetworkError.noConnection))
                                return
                            default:
                                break
                            }
                        }
                    default:
                        break
                    }
                }
                completion(.failure(error))
            }
        }
    }
}

/// Errors that can occur during network operations.
enum NetworkError: Error, LocalizedError {
    /// The URL provided was invalid.
    case invalidURL
    /// No data was returned from the request.
    case noData
    /// No internet connection available.
    case noConnection
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .noConnection:
            return "No internet connection. Please check your network settings."
        }
    }
} 
