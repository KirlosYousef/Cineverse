//
//  GetPopularMoviesUseCase.swift
//  Cineverse
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation

/// Use case for getting popular movies from the repository.
class GetPopularMoviesUseCase: GetPopularMoviesUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    
    /// Initializes the use case with a movie repository dependency.
    ///
    /// - Parameter repository: The repository used to fetch popular movies.
    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }
    
    /// Executes the use case to fetch popular movies with pagination and search support.
    ///
    /// - Parameters:
    ///   - page: The page number to fetch.
    ///   - query: Optional search query for filtering movies by name.
    /// - Returns: An array of Movie objects.
    /// - Throws: Error that occurs during the fetch operation.
    func execute(page: Int, query: String?) async throws -> [Movie] {
        return try await RetryUtility.retry(maxAttempts: 3) {
            try await self.repository.getPopularMovies(page: page, query: query)
        }
    }
} 
