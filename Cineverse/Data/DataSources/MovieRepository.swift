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
    ///   - completion: Completion handler with a Result containing an array of Movie objects or an error.
    func getPopularMovies(page: Int, query: String?, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let cacheKey = "popular_movies_page_\(page)_query_\(query ?? "")"
        if let cached: [Movie] = cacheService.get(forKey: cacheKey) {
            completion(.success(cached))
            return
        }
        var endpoint = "/movie/popular"
        var parameters: [String: Any] = ["page": page]
        if let query = query, !query.isEmpty {
            endpoint = "/search/movie"
            parameters["query"] = query
        }
        networkService.fetch(from: endpoint, parameters: parameters) { [weak self] (result: Result<MovieResponse, Error>) in
            switch result {
            case .success(let response):
                self?.cacheService.set(response.results, forKey: cacheKey)
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

/// Response model for decoding the list of movies from the API.
struct MovieResponse: Codable {
    /// The array of popular movies returned by the API.
    let results: [Movie]
} 
