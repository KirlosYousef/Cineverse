//
//  MovieRepositoryProtocol.swift
//  Cineverse
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation

/// Protocol defining movie repository operations
protocol MovieRepositoryProtocol {
    /// Fetches the list of popular movies from the repository.
    ///
    /// - Parameters:
    ///   - page: The page number to fetch.
    ///   - query: Optional search query for filtering movies by name.
    /// - Returns: An array of Movie objects.
    /// - Throws: Error that occurs during the fetch operation.
    func getPopularMovies(page: Int, query: String?) async throws -> [Movie]
} 
