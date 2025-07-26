//
//  MovieRepositoryProtocol.swift
//  MovieExplorer
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation

/// Protocol defining movie repository operations
protocol MovieRepositoryProtocol {
    /// Fetches the list of popular movies from the repository.
    ///
    /// - Parameter completion: Completion handler with a Result containing an array of Movie objects or an error.
    func getPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
} 