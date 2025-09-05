//
//  DIContainer.swift
//  Cineverse
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation

/// Dependency injection container for managing app dependencies
final class DIContainer {
    /// Shared singleton instance of the DIContainer.
    static let shared = DIContainer()
    
    /// Private initializer to enforce singleton usage.
    private init() {}
    
    // MARK: - Network Services
    /// Provides the network service for API calls.
    lazy var networkService: NetworkServiceProtocol = {
        return NetworkService()
    }()
    
    // MARK: - Repositories
    /// Provides the movie repository for accessing movie data.
    lazy var movieRepository: MovieRepositoryProtocol = {
        return MovieRepository(networkService: networkService)
    }()
    
    // MARK: - Use Cases
    /// Provides the use case for fetching popular movies.
    lazy var getPopularMoviesUseCase: GetPopularMoviesUseCaseProtocol = {
        return GetPopularMoviesUseCase(repository: movieRepository)
    }()
    
    // MARK: - Services
    /// Provides the service for managing favorite movies.
    lazy var favoritesService: FavoritesServiceProtocol = {
        return FavoritesService()
    }()
    
    /// Provides the service for caching data.
    lazy var cacheService: CacheServiceProtocol = {
        return CacheService()
    }()
} 
