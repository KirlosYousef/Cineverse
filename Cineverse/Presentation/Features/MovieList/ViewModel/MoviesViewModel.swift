//
//  MoviesViewModel.swift
//  Cineverse
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation

/// View model for managing and presenting a list of movies, including loading state and favorites.
class MoviesViewModel {
    // MARK: - Properties
    private let getPopularMoviesUseCase: GetPopularMoviesUseCaseProtocol
    private let favoritesService: FavoritesServiceProtocol
    
    private(set) var movies: [Movie] = [] {
        didSet { onMoviesChanged?() }
    }
    
    private(set) var isLoading: Bool = false {
        didSet { onLoadingChanged?(isLoading) }
    }
    
    private(set) var errorMessage: String? = nil {
        didSet { onErrorMessageChanged?(errorMessage) }
    }
    
    // Pagination and search
    private(set) var currentPage: Int = 1
    private(set) var isLastPage: Bool = false
    private(set) var searchQuery: String = ""
    private let pageSize: Int = 20 // TMDB default
    
    // Task management for cancellation
    private var currentTask: Task<Void, Never>?
    private var searchTask: Task<Void, Error>?

    // MARK: - Bindings
    var onMoviesChanged: (() -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    var onErrorMessageChanged: ((String?) -> Void)?
    
    /// Initializes the MoviesViewModel with dependencies.
    ///
    /// - Parameters:
    ///   - getPopularMoviesUseCase: The use case for fetching popular movies.
    ///   - favoritesService: The service for managing favorite movies.
    init(getPopularMoviesUseCase: GetPopularMoviesUseCaseProtocol = DIContainer.shared.getPopularMoviesUseCase,
         favoritesService: FavoritesServiceProtocol = DIContainer.shared.favoritesService) {
        self.getPopularMoviesUseCase = getPopularMoviesUseCase
        self.favoritesService = favoritesService
    }
    
    // MARK: - Public API for ViewController
    @MainActor
    func fetchMovies(reset: Bool = false) {
        // Cancel any existing task
        currentTask?.cancel()
        
        if isLoading { return }
        if reset {
            currentPage = 1
            isLastPage = false
            movies = []
        }
        
        isLoading = true
        errorMessage = nil
        
        currentTask = Task { [weak self] in
            guard let self = self else { return }
            
            do {
                let newMovies = try await getPopularMoviesUseCase.execute(
                    page: currentPage, 
                    query: searchQuery.isEmpty ? nil : searchQuery
                )
                
                // Check if task was cancelled
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    if reset {
                        self.movies = newMovies
                    } else {
                        self.movies += newMovies
                    }
                    
                    // Check if we've reached the last page
                    self.isLastPage = newMovies.count < self.pageSize
                    self.isLoading = false
                }
            } catch {
                // Check if task was cancelled
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    
                    // If this was a pagination request that failed, decrement the page
                    if !reset {
                        self.currentPage = max(1, self.currentPage - 1)
                    }
                }
            }
        }
    }

    @MainActor
    func loadNextPageIfNeeded(currentIndex: Int) {
        guard !isLastPage, !isLoading, currentIndex >= movies.count - 5 else { return }
        currentPage += 1
        fetchMovies(reset: false)
    }

    @MainActor
    func updateSearchQuery(_ query: String) {
        searchTask?.cancel()
        
        let currentQuery = query
        
        searchTask = Task { [weak self] in
            guard let self = self else { return }
            
            do {
                // Debounce delay
                try await Task.sleep(for: .milliseconds(400))
                
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    // Double-check the query hasn't changed (stale result prevention)
                    guard self.searchQuery != currentQuery else { return }
                    
                    self.searchQuery = currentQuery
                    self.fetchMovies(reset: true)
                }
            } catch {
                // Task was cancelled, ignore the error
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    self.errorMessage = "Search failed: \(error.localizedDescription)"
                }
            }
        }
    }
    
    /// Checks if a movie with the given ID is marked as favorite.
    ///
    /// - Parameter movieId: The unique identifier of the movie to check.
    /// - Returns: A Boolean value indicating whether the movie is a favorite.
    func isFavorite(movieId: Int) -> Bool {
        return favoritesService.isFavorite(movieId: movieId)
    }
    
    /// Toggles the favorite status for a movie with the given ID and notifies listeners.
    ///
    /// - Parameter movieId: The unique identifier of the movie to toggle as favorite.
    @MainActor
    func toggleFavorite(movieId: Int) {
        favoritesService.toggleFavorite(movieId: movieId)
        onMoviesChanged?()
    }
    
    /// Cancels all ongoing tasks. Call this when the view disappears or is deallocated.
    @MainActor
    func cancelAllTasks() {
        currentTask?.cancel()
        searchTask?.cancel()
    }
}
