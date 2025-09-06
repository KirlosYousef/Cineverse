//
//  MovieDetailsViewModelTests.swift
//  CineverseTests
//
//  Created by Kirlos Yousef on 10/07/2025.
//

import Testing
import Foundation
import Combine
@testable import Cineverse

struct MovieDetailsViewModelTests {
    // MARK: - Test Data
    
    let testMovie = Movie(
        id: 1,
        title: "Test Movie",
        overview: "Test Overview",
        posterPath: "/test-poster.jpg",
        releaseDate: "2025-07-10",
        voteAverage: 8.5
    )
    
    let movieWithoutPoster = Movie(
        id: 2,
        title: "No Poster Movie",
        overview: "Test Overview",
        posterPath: nil,
        releaseDate: "2025-07-10",
        voteAverage: 8.5
    )
    
    // MARK: - Tests
    
    @Test("View model correctly exposes movie title")
    @MainActor
    func testMovieTitle() {
        // Given
        let sut = MovieDetailsViewModel(movie: testMovie)
        
        // Then
        #expect(sut.title == testMovie.title)
    }
    
    @Test("View model correctly exposes movie overview")
    @MainActor
    func testMovieOverview() {
        // Given
        let sut = MovieDetailsViewModel(movie: testMovie)
        
        // Then
        #expect(sut.overview == testMovie.overview)
    }
    
    @Test("View model correctly exposes movie release date")
    @MainActor
    func testMovieReleaseDate() {
        // Given
        let sut = MovieDetailsViewModel(movie: testMovie)
        
        // Then
        #expect(sut.releaseDate == testMovie.releaseDate)
    }
    
    @Test("View model correctly constructs poster URL")
    @MainActor
    func testMoviePosterURL() {
        // Given
        let sut = MovieDetailsViewModel(movie: testMovie)
        
        // Then
        #expect(sut.posterURL == testMovie.posterURL)
        #expect(sut.posterURL?.absoluteString == "https://image.tmdb.org/t/p/w500/test-poster.jpg")
    }
} 
