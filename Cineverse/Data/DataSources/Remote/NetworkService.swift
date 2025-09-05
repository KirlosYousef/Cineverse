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
    /// - Returns: The decoded object of type T.
    /// - Throws: NetworkError or other errors that occur during the request.
    func fetch<T: Codable>(from endpoint: String, parameters: [String: Any]? = nil) async throws -> T {
        // Check network connectivity first
        guard NetworkReachabilityManager.default?.isReachable == true else {
            throw NetworkError.noConnection
        }
        
        var urlString = "\(baseURL)\(endpoint)?api_key=\(apiKey)"
        if let parameters = parameters {
            for (key, value) in parameters {
                let valueString = String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                urlString += "&\(key)=\(valueString)"
            }
        }
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let data = try await AF.request(url).serializingDecodable(T.self).value
            return data
        } catch {
            print("error: \(error)")
            
            // Send analytics signal for network error
            TelemetryService.shared.send(
                TelemetryService.Signal.networkError,
                payload: [
                    "endpoint": endpoint,
                    "error": error.localizedDescription
                ]
            )
            
            // Check if it's a network connectivity error
            if let afError = error as? AFError {
                switch afError {
                case .sessionTaskFailed(let underlyingError):
                    if let urlError = underlyingError as? URLError {
                        switch urlError.code {
                        case .notConnectedToInternet, .networkConnectionLost:
                            throw NetworkError.noConnection
                        default:
                            break
                        }
                    }
                default:
                    break
                }
            }
            
            throw error
        }
    }
    
    /// Fetches popular movies with pagination.
    ///
    /// - Parameter page: The page number to fetch.
    /// - Returns: A MovieResponse containing the popular movies.
    /// - Throws: NetworkError or other errors that occur during the request.
    func fetchPopular(page: Int) async throws -> MovieResponse {
        return try await fetch(from: "/movie/popular", parameters: ["page": page])
    }
    
    /// Searches for movies with a query and pagination.
    ///
    /// - Parameters:
    ///   - query: The search query.
    ///   - page: The page number to fetch.
    /// - Returns: A MovieResponse containing the search results.
    /// - Throws: NetworkError or other errors that occur during the request.
    func searchMovies(query: String, page: Int) async throws -> MovieResponse {
        return try await fetch(from: "/search/movie", parameters: ["query": query, "page": page])
    }
    
    /// Fetches detailed information for a specific movie.
    ///
    /// - Parameter id: The movie ID.
    /// - Returns: A Movie object with detailed information.
    /// - Throws: NetworkError or other errors that occur during the request.
    func fetchDetails(id: Int) async throws -> Movie {
        return try await fetch(from: "/movie/\(id)", parameters: nil)
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
