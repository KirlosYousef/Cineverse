//
//  FavoritesServiceProtocol.swift
//  MovieExplorer
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation

/// Protocol defining favorites service operations
protocol FavoritesServiceProtocol {
    /// Toggles the favorite status for a movie with the given ID.
    ///
    /// - Parameter movieId: The unique identifier of the movie to toggle as favorite.
    func toggleFavorite(movieId: Int)
    
    /// Checks if a movie with the given ID is marked as favorite.
    ///
    /// - Parameter movieId: The unique identifier of the movie to check.
    /// - Returns: A Boolean value indicating whether the movie is a favorite.
    func isFavorite(movieId: Int) -> Bool
    
    /// Retrieves the list of favorite movie IDs.
    ///
    /// - Returns: An array of movie IDs marked as favorite.
    func getFavoriteMovieIds() -> [Int]
} 