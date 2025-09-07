//
//  CacheServiceTests.swift
//  CineverseTests
//
//  Created by Kirlos Yousef on 10/07/2025.
//

import Testing
import Foundation
@testable import Cineverse

struct CacheServiceTests {
    // MARK: - Test Data
    
    let testMovie = Movie(
        id: 1,
        title: "Test Movie",
        overview: "Test Overview",
        posterPath: "/test-poster.jpg",
        releaseDate: "2025-07-10",
        voteAverage: 8.5
    )
    
    let testMovies = [
        Movie(id: 1, title: "Test Movie 1", overview: "Overview 1", posterPath: "/poster1.jpg", releaseDate: "2025-07-10", voteAverage: 7.5),
        Movie(id: 2, title: "Test Movie 2", overview: "Overview 2", posterPath: "/poster2.jpg", releaseDate: "2025-07-10", voteAverage: 8.0)
    ]
    
    // MARK: - Tests
    
    @Test("Cache service can store and retrieve single movie")
    func testStoreAndRetrieveSingleMovie() {
        // Given
        let sut = CacheService()
        let key = "test_movie"
        
        // When - Store movie
        sut.set(testMovie, forKey: key)
        
        // Then - Retrieve movie
        let retrievedMovie: Movie? = sut.get(forKey: key)
        #expect(retrievedMovie != nil)
        #expect(retrievedMovie == testMovie)
    }
    
    @Test("Cache service can store and retrieve array of movies")
    func testStoreAndRetrieveMovieArray() {
        // Given
        let sut = CacheService()
        let key = "test_movies"
        
        // When - Store movies
        sut.set(testMovies, forKey: key)
        
        // Then - Retrieve movies
        let retrievedMovies: [Movie]? = sut.get(forKey: key)
        #expect(retrievedMovies != nil)
        #expect(retrievedMovies == testMovies)
    }
    
    @Test("Cache service can clear all cached data")
    func testClearAll() {
        // Given
        let sut = CacheService()
        let key1 = "test_movie_1"
        let key2 = "test_movie_2"
        sut.set(testMovie, forKey: key1)
        sut.set(testMovies, forKey: key2)
        
        // When - Clear all
        sut.clearAll()
        
        // Then
        let retrievedMovie1: Movie? = sut.get(forKey: key1)
        let retrievedMovies2: [Movie]? = sut.get(forKey: key2)
        #expect(retrievedMovie1 == nil)
        #expect(retrievedMovies2 == nil)
    }
    
    @Test("Cache service handles different data types")
    func testDifferentDataTypes() {
        // Given
        let sut = CacheService()
        let stringKey = "test_string"
        let intKey = "test_int"
        let boolKey = "test_bool"
        
        // When - Store different types
        sut.set("Hello World", forKey: stringKey)
        sut.set(42, forKey: intKey)
        sut.set(true, forKey: boolKey)
        
        // Then - Retrieve different types
        let retrievedString: String? = sut.get(forKey: stringKey)
        let retrievedInt: Int? = sut.get(forKey: intKey)
        let retrievedBool: Bool? = sut.get(forKey: boolKey)
        
        #expect(retrievedString == "Hello World")
        #expect(retrievedInt == 42)
        #expect(retrievedBool == true)
    }
    
    @Test("Cache service overwrites existing data")
    func testOverwriteExistingData() {
        // Given
        let sut = CacheService()
        let key = "test_movie"
        let newMovie = Movie(
            id: 2,
            title: "New Movie",
            overview: "New Overview",
            posterPath: "/new-poster.jpg",
            releaseDate: "2025-08-10",
            voteAverage: 9.0
        )
        
        // When - Store original movie
        sut.set(testMovie, forKey: key)
        
        // Then - Verify original is stored
        let originalMovie: Movie? = sut.get(forKey: key)
        #expect(originalMovie == testMovie)
        
        // When - Overwrite with new movie
        sut.set(newMovie, forKey: key)
        
        // Then - Verify new movie is stored
        let retrievedMovie: Movie? = sut.get(forKey: key)
        #expect(retrievedMovie == newMovie)
        #expect(retrievedMovie != testMovie)
    }
}
