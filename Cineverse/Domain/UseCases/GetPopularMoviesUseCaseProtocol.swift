//
//  GetPopularMoviesUseCaseProtocol.swift
//  Cineverse
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation

/// Protocol defining the get popular movies use case
protocol GetPopularMoviesUseCaseProtocol {
    /// Executes the use case to fetch popular movies.
    ///
    /// - Parameters:
    ///   - page: The page number to fetch.
    ///   - query: Optional search query for filtering movies by name.
    /// - Returns: An array of Movie objects.
    /// - Throws: Error that occurs during the fetch operation.
    func execute(page: Int, query: String?) async throws -> [Movie]
} 
