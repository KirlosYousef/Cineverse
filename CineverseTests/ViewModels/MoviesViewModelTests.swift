//
//  MoviesViewModelTests.swift
//  CineverseTests
//
//  Created by Kirlos Yousef on 10/07/2025.
//

import Testing
import Foundation
@testable import Cineverse

struct MoviesViewModelTests {
    // MARK: - Test Doubles
    
    class MockGetPopularMoviesUseCase: GetPopularMoviesUseCaseProtocol {
        var executeCalled = false
        var lastPage: Int?
        var lastQuery: String?
        var resultToReturn: Result<[Movie], Error>?
        
        func execute(page: Int, query: String?) async throws -> [Movie] {
            executeCalled = true
            lastPage = page
            lastQuery = query
            if let result = resultToReturn {
                switch result {
                case .success(let movies):
                    return movies
                case .failure(let error):
                    throw error
                }
            }
            return []
        }
    }
    
    class MockFavoritesService: FavoritesServiceProtocol {
        var toggleFavoriteCalled = false
        var lastToggledMovieId: Int?
        var isFavoriteCalled = false
        var lastCheckedMovieId: Int?
        var getFavoriteMovieIdsCalled = false
        var favoriteMovieIds: [Int] = []
        
        func toggleFavorite(movieId: Int) {
            toggleFavoriteCalled = true
            lastToggledMovieId = movieId
            if favoriteMovieIds.contains(movieId) {
                favoriteMovieIds.removeAll { $0 == movieId }
            } else {
                favoriteMovieIds.append(movieId)
            }
        }
        
        func isFavorite(movieId: Int) -> Bool {
            isFavoriteCalled = true
            lastCheckedMovieId = movieId
            return favoriteMovieIds.contains(movieId)
        }
        
        func getFavoriteMovieIds() -> [Int] {
            getFavoriteMovieIdsCalled = true
            return favoriteMovieIds
        }
    }
    
    // MARK: - Test Data
    
    let testMovies = [
        Movie(id: 1, title: "Test Movie 1", overview: "Overview 1", posterPath: "/poster1.jpg", releaseDate: "2025-07-10", voteAverage: 7.5),
        Movie(id: 2, title: "Test Movie 2", overview: "Overview 2", posterPath: "/poster2.jpg", releaseDate: "2025-07-10", voteAverage: 8.0)
    ]
    
    let testMoviesPage1 = Array(1...20).map { id in
        Movie(id: id, title: "Test Movie \(id)", overview: "Overview \(id)", posterPath: "/poster\(id).jpg", releaseDate: "2025-07-10", voteAverage: 7.5)
    }
    
    let testMoviesPage2 = Array(21...25).map { id in
        Movie(id: id, title: "Test Movie \(id)", overview: "Overview \(id)", posterPath: "/poster\(id).jpg", releaseDate: "2025-07-10", voteAverage: 7.5)
    }
    
    // MARK: - Tests
    
    @Test("Fetching movies successfully updates the view model")
    @MainActor
    func testFetchMoviesSuccess() async throws {
        // Given
        let mockUseCase = MockGetPopularMoviesUseCase()
        let mockFavoritesService = MockFavoritesService()
        let sut = MoviesViewModel(getPopularMoviesUseCase: mockUseCase, favoritesService: mockFavoritesService)
        mockUseCase.resultToReturn = .success(testMovies)
        
        // When
        sut.fetchMovies()
        
        // Then
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(mockUseCase.executeCalled)
        #expect(sut.movies == testMovies)
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == nil)
        #expect(sut.currentPage == 1)
    }
    
    @Test("Fetching movies with error updates error state")
    @MainActor
    func testFetchMoviesFailure() async throws {
        // Given
        let mockUseCase = MockGetPopularMoviesUseCase()
        let mockFavoritesService = MockFavoritesService()
        let sut = MoviesViewModel(getPopularMoviesUseCase: mockUseCase, favoritesService: mockFavoritesService)
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
    @MainActor
    func testFetchMoviesUpdatesLoadingState() async throws {
        // Given
        let mockUseCase = MockGetPopularMoviesUseCase()
        let mockFavoritesService = MockFavoritesService()
        let sut = MoviesViewModel(getPopularMoviesUseCase: mockUseCase, favoritesService: mockFavoritesService)
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
    @MainActor
    func testBindingsAreTriggered() async throws {
        // Given
        let mockUseCase = MockGetPopularMoviesUseCase()
        let mockFavoritesService = MockFavoritesService()
        let sut = MoviesViewModel(getPopularMoviesUseCase: mockUseCase, favoritesService: mockFavoritesService)
        mockUseCase.resultToReturn = .success([])
        
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
    
    @Test("Pagination works correctly")
    @MainActor
    func testPagination() async throws {
        // Given
        let mockUseCase = MockGetPopularMoviesUseCase()
        let mockFavoritesService = MockFavoritesService()
        let sut = MoviesViewModel(getPopularMoviesUseCase: mockUseCase, favoritesService: mockFavoritesService)
        
        // First page returns 20 movies
        mockUseCase.resultToReturn = .success(testMoviesPage1)
        
        // When - First page
        sut.fetchMovies()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        #expect(sut.currentPage == 1)
        #expect(mockUseCase.lastPage == 1)
        #expect(sut.movies.count == 20)
        #expect(!sut.isLoading) // Ensure loading is complete
        #expect(!sut.isLastPage) // Should not be last page
        
        // Reset mock state for second call and set up second page response
        mockUseCase.executeCalled = false
        mockUseCase.lastPage = nil
        mockUseCase.resultToReturn = .success(testMoviesPage2)
        
        // When - Load next page (need to be at index that triggers pagination)
        sut.loadNextPageIfNeeded(currentIndex: 15)
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        #expect(sut.currentPage == 2)
        #expect(mockUseCase.executeCalled)
        #expect(mockUseCase.lastPage == 2)
    }
    
    @Test("Search functionality works correctly")
    @MainActor
    func testSearch() async throws {
        // Given
        let mockUseCase = MockGetPopularMoviesUseCase()
        let mockFavoritesService = MockFavoritesService()
        let sut = MoviesViewModel(getPopularMoviesUseCase: mockUseCase, favoritesService: mockFavoritesService)
        mockUseCase.resultToReturn = .success(testMovies)
        
        // When
        sut.updateSearchQuery("batman")
        try await Task.sleep(nanoseconds: 500_000_000) // Wait for debounce
        
        // Then
        #expect(mockUseCase.executeCalled)
        #expect(mockUseCase.lastQuery == "batman")
        #expect(sut.searchQuery == "batman")
    }
    
    @Test("Favorites functionality works correctly")
    @MainActor
    func testFavorites() async throws {
        // Given
        let mockUseCase = MockGetPopularMoviesUseCase()
        let mockFavoritesService = MockFavoritesService()
        let sut = MoviesViewModel(getPopularMoviesUseCase: mockUseCase, favoritesService: mockFavoritesService)
        
        // When
        sut.toggleFavorite(movieId: 1)
        
        // Then
        #expect(mockFavoritesService.toggleFavoriteCalled)
        #expect(mockFavoritesService.lastToggledMovieId == 1)
        
        // When
        _ = sut.isFavorite(movieId: 1)
        
        // Then
        #expect(mockFavoritesService.isFavoriteCalled)
        #expect(mockFavoritesService.lastCheckedMovieId == 1)
    }
    
    @Test("Task cancellation works correctly")
    @MainActor
    func testTaskCancellation() async throws {
        // Given
        let mockUseCase = MockGetPopularMoviesUseCase()
        let mockFavoritesService = MockFavoritesService()
        let sut = MoviesViewModel(getPopularMoviesUseCase: mockUseCase, favoritesService: mockFavoritesService)
        mockUseCase.resultToReturn = .success(testMovies)
        
        // When
        sut.fetchMovies()
        try await Task.sleep(nanoseconds: 10_000_000)
        sut.cancelAllTasks()
        
        // Then
        #expect(mockUseCase.executeCalled)
        // Verify that cancelAllTasks doesn't crash and can be called multiple times
        sut.cancelAllTasks()
        sut.cancelAllTasks()
    }
}
