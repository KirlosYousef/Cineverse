//
//  FavoritesServiceProtocol.swift
//  MovieExplorer
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation

/// Protocol defining favorites service operations
protocol FavoritesServiceProtocol {
    func toggleFavorite(movieId: Int)
    func isFavorite(movieId: Int) -> Bool
    func getFavoriteMovieIds() -> [Int]
} 