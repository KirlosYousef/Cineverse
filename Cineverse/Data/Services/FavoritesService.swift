//
//  FavoritesService.swift
//  Cineverse
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation

/// Service for managing favorite movies using UserDefaults.
class FavoritesService: FavoritesServiceProtocol {
    /// The UserDefaults instance used for persistence.
    private let userDefaults = UserDefaults.standard
    /// The key used to store favorite movie IDs in UserDefaults.
    private let favoritesKey = "favorite_movie_ids"
    
    /// Toggles the favorite status for a movie with the given ID.
    ///
    /// - Parameter movieId: The unique identifier of the movie to toggle as favorite.
    func toggleFavorite(movieId: Int) {
        var favorites = getFavoriteMovieIds()
        
        if favorites.contains(movieId) {
            favorites.removeAll { $0 == movieId }
        } else {
            favorites.append(movieId)
        }
        
        userDefaults.set(favorites, forKey: favoritesKey)
    }
    
    /// Checks if a movie with the given ID is marked as favorite.
    ///
    /// - Parameter movieId: The unique identifier of the movie to check.
    /// - Returns: A Boolean value indicating whether the movie is a favorite.
    func isFavorite(movieId: Int) -> Bool {
        return getFavoriteMovieIds().contains(movieId)
    }
    
    /// Retrieves the list of favorite movie IDs.
    ///
    /// - Returns: An array of movie IDs marked as favorite.
    func getFavoriteMovieIds() -> [Int] {
        return userDefaults.array(forKey: favoritesKey) as? [Int] ?? []
    }
} 
