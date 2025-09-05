//
//  CacheServiceProtocol.swift
//  Cineverse
//
//  Created by Kirlos Yousef on 11/07/2025.
//

import Foundation

/// Protocol defining cache service operations
protocol CacheServiceProtocol {
    /// Retrieves a cached object for the given key.
    func get<T: Codable>(forKey key: String) -> T?
    /// Caches an object for the given key.
    func set<T: Codable>(_ object: T, forKey key: String)
    /// Clears the cached object for the given key.
    func clear(forKey key: String)
    /// Clears all cached objects.
    func clearAll()
} 