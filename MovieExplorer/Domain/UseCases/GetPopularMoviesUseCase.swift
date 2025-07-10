//
//  GetPopularMoviesUseCase.swift
//  MovieExplorer
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation

/// Use case for getting popular movies
class GetPopularMoviesUseCase: GetPopularMoviesUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(completion: @escaping (Result<[Movie], Error>) -> Void) {
        repository.getPopularMovies(completion: completion)
    }
} 