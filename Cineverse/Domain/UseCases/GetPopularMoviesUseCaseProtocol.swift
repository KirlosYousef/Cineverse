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
    /// - Parameter completion: Completion handler with a Result containing an array of Movie objects or an error.
    func execute(completion: @escaping (Result<[Movie], Error>) -> Void)
} 
