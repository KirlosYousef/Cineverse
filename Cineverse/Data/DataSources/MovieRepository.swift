//
//  MovieRepository.swift
//  Cineverse
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation

/// Movie repository implementation for fetching movie data from the network service.
class MovieRepository: MovieRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let cacheService: CacheServiceProtocol
    
    /// Initializes the MovieRepository with a network service dependency.
    ///
    /// - Parameter networkService: The network service used to fetch movie data.
    init(networkService: NetworkServiceProtocol, cacheService: CacheServiceProtocol = DIContainer.shared.cacheService) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    /// Fetches the list of popular movies from the network service with pagination and search support.
    ///
    /// - Parameters:
    ///   - page: The page number to fetch.
    ///   - query: Optional search query for filtering movies by name.
    /// - Returns: An array of Movie objects.
    /// - Throws: Error that occurs during the fetch operation.
    func getPopularMovies(page: Int, query: String?) async throws -> [Movie] {
        let cacheKey = "popular_movies_page_\(page)_query_\(query ?? "")"
        
        // Check cache first
        if let cachedMovies: [Movie] = cacheService.get(forKey: cacheKey) {
            return cachedMovies
        }
        
        let response: MovieResponse
        if let query = query, !query.isEmpty {
            response = try await networkService.searchMovies(query: query, page: page)
        } else {
            response = try await networkService.fetchPopular(page: page)
        }
        
        // Cache the results
        cacheService.set(response.results, forKey: cacheKey)
        
        return response.results
    }
}
