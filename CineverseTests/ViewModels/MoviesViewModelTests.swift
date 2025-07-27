//
//  MoviesViewModelTests.swift
//  CineverseTests
//
//  Created by Kirlos Yousef on 10/07/2025.
//

import Testing
import Foundation
@testable import Cineverse

final class MoviesViewModelTests {
    // MARK: - Test Doubles
    
    class MockGetPopularMoviesUseCase: GetPopularMoviesUseCaseProtocol {
        var executeCalled = false
        var resultToReturn: Result<[Movie], Error>?
        
        func execute(page: Int, query: String?, completion: @escaping (Result<[Cineverse.Movie], any Error>) -> Void) {
            executeCalled = true
            if let result = resultToReturn {
                completion(result)
            }
        }
    }
    
    class MockFavoritesService: FavoritesServiceProtocol {
        var toggleFavoriteCalled = false
        var isFavoriteCalled = false
        var getFavoriteMovieIdsCalled = false
        var favoriteMovieIds: [Int] = []
        
        func toggleFavorite(movieId: Int) {
            toggleFavoriteCalled = true
            if favoriteMovieIds.contains(movieId) {
                favoriteMovieIds.removeAll { $0 == movieId }
            } else {
                favoriteMovieIds.append(movieId)
            }
        }
        
        func isFavorite(movieId: Int) -> Bool {
            isFavoriteCalled = true
            return favoriteMovieIds.contains(movieId)
        }
        
        func getFavoriteMovieIds() -> [Int] {
            getFavoriteMovieIdsCalled = true
            return favoriteMovieIds
        }
    }
    
    // MARK: - Properties
    
    var sut: MoviesViewModel!
    var mockUseCase: MockGetPopularMoviesUseCase!
    var mockFavoritesService: MockFavoritesService!
    
    // MARK: - Setup & Teardown
    
    func setUp() async throws {
        mockUseCase = MockGetPopularMoviesUseCase()
        mockFavoritesService = MockFavoritesService()
        sut = MoviesViewModel(getPopularMoviesUseCase: mockUseCase, favoritesService: mockFavoritesService)
    }
    
    func tearDown() {
        sut = nil
        mockUseCase = nil
        mockFavoritesService = nil
    }
    
    // MARK: - Tests
    
    @Test("Fetching movies successfully updates the view model")
    func testFetchMoviesSuccess() async throws {
        try await setUp()
        defer { tearDown() }
        
        // Given
        let expectedMovies = [
            Movie(id: 1, title: "Test Movie 1", overview: "Overview 1", posterPath: "/poster1.jpg", releaseDate: "2025-07-10", voteAverage: 7.5),
            Movie(id: 2, title: "Test Movie 2", overview: "Overview 2", posterPath: "/poster2.jpg", releaseDate: "2025-07-10", voteAverage: 8.0)
        ]
        mockUseCase.resultToReturn = .success(expectedMovies)
        
        // When
        sut.fetchMovies()
        
        // Then
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(mockUseCase.executeCalled)
        #expect(sut.movies == expectedMovies)
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == nil)
    }
    
    @Test("Fetching movies with error updates error state")
    func testFetchMoviesFailure() async throws {
        try await setUp()
        defer { tearDown() }
        
        // Given
        let expectedError = NSError(domain: "test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockUseCase.resultToReturn = .failure(expectedError)
        
        // When
        sut.fetchMovies()
        
        // Then
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(mockUseCase.executeCalled)
        #expect(sut.movies.isEmpty)
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == expectedError.localizedDescription)
    }
    
    @Test("Loading state is properly updated during fetch")
    func testFetchMoviesUpdatesLoadingState() async throws {
        try await setUp()
        defer { tearDown() }
        
        // Given
        mockUseCase.resultToReturn = .success([])
        
        // When
        var loadingStates: [Bool] = []
        sut.onLoadingChanged = { isLoading in
            loadingStates.append(isLoading)
        }
        sut.fetchMovies()
        
        // Then
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(loadingStates == [true, false])
    }
    
    @Test("Data bindings are triggered appropriately")
    func testBindingsAreTriggered() async throws {
        try await setUp()
        defer { tearDown() }
        
        // Given
        var loadingChangedCalled = false
        var errorMessageChangedCalled = false
        
        sut.onLoadingChanged = { _ in loadingChangedCalled = true }
        sut.onErrorMessageChanged = { _ in errorMessageChangedCalled = true }
        
        // When
        sut.fetchMovies()
        
        // Then
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(loadingChangedCalled)
        #expect(errorMessageChangedCalled)
    }
}
