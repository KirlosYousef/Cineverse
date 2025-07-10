//
//  MovieRepository.swift
//  MovieExplorer
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation

/// Movie repository implementation
class MovieRepository: MovieRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        networkService.fetch(from: "/movie/popular") { (result: Result<MovieResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct MovieResponse: Codable {
    let results: [Movie]
} 