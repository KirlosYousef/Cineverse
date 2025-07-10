//
//  NetworkServiceProtocol.swift
//  MovieExplorer
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation

/// Protocol defining network service operations
protocol NetworkServiceProtocol {
    func fetch<T: Codable>(from endpoint: String, completion: @escaping (Result<T, Error>) -> Void)
} 