//
//  FavoritesService.swift
//  MovieExplorer
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation

/// Service for managing favorite movies using UserDefaults
class FavoritesService: FavoritesServiceProtocol {
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "favorite_movie_ids"
    
    func toggleFavorite(movieId: Int) {
        var favorites = getFavoriteMovieIds()
        
        if favorites.contains(movieId) {
            favorites.removeAll { $0 == movieId }
        } else {
            favorites.append(movieId)
        }
        
        userDefaults.set(favorites, forKey: favoritesKey)
    }
    
    func isFavorite(movieId: Int) -> Bool {
        return getFavoriteMovieIds().contains(movieId)
    }
    
    func getFavoriteMovieIds() -> [Int] {
        return userDefaults.array(forKey: favoritesKey) as? [Int] ?? []
    }
} 
