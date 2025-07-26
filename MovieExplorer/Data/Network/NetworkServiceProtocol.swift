//
//  NetworkServiceProtocol.swift
//  MovieExplorer
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
    ///   - completion: Completion handler with a Result containing the decoded object or an error.
    func fetch<T: Codable>(from endpoint: String, completion: @escaping (Result<T, Error>) -> Void)
} 