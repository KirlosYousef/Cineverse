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
    /// - Returns: The decoded object of type T.
    /// - Throws: NetworkError or other errors that occur during the request.
    func fetch<T: Codable>(from endpoint: String, parameters: [String: Any]?) async throws -> T
    
    /// Fetches popular movies with pagination.
    ///
    /// - Parameter page: The page number to fetch.
    /// - Returns: A MovieResponse containing the popular movies.
    /// - Throws: NetworkError or other errors that occur during the request.
    func fetchPopular(page: Int) async throws -> MovieResponse
    
    /// Searches for movies with a query and pagination.
    ///
    /// - Parameters:
    ///   - query: The search query.
    ///   - page: The page number to fetch.
    /// - Returns: A MovieResponse containing the search results.
    /// - Throws: NetworkError or other errors that occur during the request.
    func searchMovies(query: String, page: Int) async throws -> MovieResponse
    
    /// Fetches detailed information for a specific movie.
    ///
    /// - Parameter id: The movie ID.
    /// - Returns: A Movie object with detailed information.
    /// - Throws: NetworkError or other errors that occur during the request.
    func fetchDetails(id: Int) async throws -> Movie
} 
