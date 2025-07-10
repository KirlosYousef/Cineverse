//
//  MovieDetailsViewModelTests.swift
//  MovieExplorerTests
//
//  Created by Kirlos Yousef on 10/07/2025.
//

import Testing
import Foundation
@testable import MovieExplorer

final class MovieDetailsViewModelTests {
    // MARK: - Properties
    
    var sut: MovieDetailsViewModel!
    let testMovie = Movie(
        id: 1,
        title: "Test Movie",
        overview: "Test Overview",
        posterPath: "/test-poster.jpg",
        releaseDate: "2025-07-10",
        voteAverage: 8.5
    )
    
    // MARK: - Setup & Teardown
    
    func setUp() {
        sut = MovieDetailsViewModel(movie: testMovie)
    }
    
    func tearDown() {
        sut = nil
    }
    
    // MARK: - Tests
    
    @Test("View model correctly exposes movie title")
    func testMovieTitle() {
        setUp()
        defer { tearDown() }
        
        #expect(sut.title == testMovie.title)
    }
    
    @Test("View model correctly exposes movie overview")
    func testMovieOverview() {
        setUp()
        defer { tearDown() }
        
        #expect(sut.overview == testMovie.overview)
    }
    
    @Test("View model correctly exposes movie release date")
    func testMovieReleaseDate() {
        setUp()
        defer { tearDown() }
        
        #expect(sut.releaseDate == testMovie.releaseDate)
    }
    
    @Test("View model correctly constructs poster URL")
    func testMoviePosterURL() {
        setUp()
        defer { tearDown() }
        
        #expect(sut.posterURL == testMovie.posterURL)
    }
    
    @Test("View model handles nil poster path")
    func testNilPosterURL() {
        let movieWithoutPoster = Movie(
            id: 2,
            title: "No Poster Movie",
            overview: "Test Overview",
            posterPath: nil,
            releaseDate: "2025-07-10",
            voteAverage: 8.5
        )
        sut = MovieDetailsViewModel(movie: movieWithoutPoster)
        defer { tearDown() }
        
        #expect(sut.posterURL == nil)
    }
} 