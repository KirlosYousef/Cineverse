//
//  GetPopularMoviesUseCase.swift
//  MovieExplorer
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
    
    /// Executes the use case to fetch popular movies.
    ///
    /// - Parameter completion: Completion handler with a Result containing an array of Movie objects or an error.
    func execute(completion: @escaping (Result<[Movie], Error>) -> Void) {
        repository.getPopularMovies(completion: completion)
    }
} 