//
//  GetPopularMoviesUseCaseProtocol.swift
//  MovieExplorer
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation

/// Protocol defining the get popular movies use case
protocol GetPopularMoviesUseCaseProtocol {
    func execute(completion: @escaping (Result<[Movie], Error>) -> Void)
} 