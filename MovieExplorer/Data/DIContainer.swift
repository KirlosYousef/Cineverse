//
//  DIContainer.swift
//  MovieExplorer
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation

/// Dependency injection container for managing app dependencies
final class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    // MARK: - Network Services
    lazy var networkService: NetworkServiceProtocol = {
        return NetworkService()
    }()
    
    // MARK: - Repositories
    lazy var movieRepository: MovieRepositoryProtocol = {
        return MovieRepository(networkService: networkService)
    }()
    
    // MARK: - Use Cases
    lazy var getPopularMoviesUseCase: GetPopularMoviesUseCaseProtocol = {
        return GetPopularMoviesUseCase(repository: movieRepository)
    }()
    
    // MARK: - Services
    lazy var favoritesService: FavoritesServiceProtocol = {
        return FavoritesService()
    }()
} 