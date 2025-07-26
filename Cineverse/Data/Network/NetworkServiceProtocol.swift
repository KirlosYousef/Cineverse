//
//  NetworkServiceProtocol.swift
//  Cineverse
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation

/// Protocol defining network service operations
protocol NetworkServiceProtocol {
    /// Fetches data from a given endpoint and decodes it into the specified Codable type.
    ///
    /// - Parameters:
    ///   - endpoint: The API endpoint to fetch data from (e.g., "/movie/popular").
    ///   - parameters: Optional query parameters for the request (e.g., ["page": 2, "query": "batman"]).
    ///   - completion: Completion handler with a Result containing the decoded object or an error.
    func fetch<T: Codable>(from endpoint: String, parameters: [String: Any]?, completion: @escaping (Result<T, Error>) -> Void)
} 
