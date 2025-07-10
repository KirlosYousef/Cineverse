//
//  MovieRepositoryProtocol.swift
//  MovieExplorer
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation

/// Protocol defining movie repository operations
protocol MovieRepositoryProtocol {
    func getPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
} 