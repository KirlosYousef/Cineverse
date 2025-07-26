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
    ///   - completion: Completion handler with a Result containing an array of Movie objects or an error.
    func execute(page: Int, query: String?, completion: @escaping (Result<[Movie], Error>) -> Void)
} 
