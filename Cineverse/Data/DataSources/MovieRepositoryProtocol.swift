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
    ///   - completion: Completion handler with a Result containing an array of Movie objects or an error.
    func getPopularMovies(page: Int, query: String?, completion: @escaping (Result<[Movie], Error>) -> Void)
} 
