//
//  CacheService.swift
//  Cineverse
//
//  Created by Kirlos Yousef on 11/07/2025.
//

import Foundation

/// Service for caching Codable objects in memory and disk.
class CacheService: CacheServiceProtocol {
    private let memoryCache = NSCache<NSString, NSData>()
    private let userDefaults = UserDefaults.standard
    private let diskPrefix = "cineverse_cache_"
    
    /// Retrieves a cached object for the given key.
    func get<T: Codable>(forKey key: String) -> T? {
        let cacheKey = diskPrefix + key
        // Try memory cache first
        if let data = memoryCache.object(forKey: cacheKey as NSString) {
            return try? JSONDecoder().decode(T.self, from: data as Data)
        }
        // Try disk cache
        if let data = userDefaults.data(forKey: cacheKey) {
            // Store in memory for next time
            memoryCache.setObject(data as NSData, forKey: cacheKey as NSString)
            return try? JSONDecoder().decode(T.self, from: data)
        }
        return nil
    }
    
    /// Caches an object for the given key.
    func set<T: Codable>(_ object: T, forKey key: String) {
        let cacheKey = diskPrefix + key
        if let data = try? JSONEncoder().encode(object) {
            memoryCache.setObject(data as NSData, forKey: cacheKey as NSString)
            userDefaults.set(data, forKey: cacheKey)
        }
    }
    
    /// Clears the cached object for the given key.
    func clear(forKey key: String) {
        let cacheKey = diskPrefix + key
        memoryCache.removeObject(forKey: cacheKey as NSString)
        userDefaults.removeObject(forKey: cacheKey)
    }
    
    /// Clears all cached objects.
    func clearAll() {
        memoryCache.removeAllObjects()
        for (key, _) in userDefaults.dictionaryRepresentation() {
            if key.hasPrefix(diskPrefix) {
                userDefaults.removeObject(forKey: key)
            }
        }
    }
} 
