//
//  FavoritesServiceTests.swift
//  MovieExplorerTests
//
//  Created by Kirlos Yousef on 10/07/2025.
//

import Testing
@testable import MovieExplorer

struct FavoritesServiceTests {
    // MARK: - Properties
    
    var sut: FavoritesService!
    let testMovieId = 1
    
    // MARK: - Setup & Teardown
    
    func setUp() {
        sut = FavoritesService()
        UserDefaults.standard.removeObject(forKey: "favorite_movie_ids")
    }
    
    func tearDown() {
        UserDefaults.standard.removeObject(forKey: "favorite_movie_ids")
        sut = nil
    }
    
    // MARK: - Tests
    
    @Test("Adding a movie to favorites")
    func testToggleFavoriteAdd() async throws {
        setUp()
        defer { tearDown() }
        
        sut.toggleFavorite(movieId: testMovieId)
        #expect(sut.isFavorite(movieId: testMovieId))
    }
    
    @Test("Removing a movie from favorites")
    func testToggleFavoriteRemove() async throws {
        setUp()
        defer { tearDown() }
        
        // Add then remove
        sut.toggleFavorite(movieId: testMovieId)
        sut.toggleFavorite(movieId: testMovieId)
        #expect(!sut.isFavorite(movieId: testMovieId))
    }
    
    @Test("Getting all favorite movie IDs")
    func testGetFavoriteMovieIds() async throws {
        setUp()
        defer { tearDown() }
        
        let movieIds = [1, 2, 3]
        movieIds.forEach { sut.toggleFavorite(movieId: $0) }
        
        let favorites = sut.getFavoriteMovieIds()
        #expect(favorites.count == movieIds.count)
        #expect(Set(favorites) == Set(movieIds))
    }
} 