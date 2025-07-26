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
    private var debounceTimer: Timer?
    private let pageSize: Int = 20 // TMDB default

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
    func fetchMovies(reset: Bool = false) {
        if isLoading { return }
        if reset {
            currentPage = 1
            isLastPage = false
            movies = []
        }
        isLoading = true
        errorMessage = nil
        getPopularMoviesUseCase.execute(page: currentPage, query: searchQuery.isEmpty ? nil : searchQuery) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let newMovies):
                    if reset {
                        self?.movies = newMovies
                    } else {
                        self?.movies += newMovies
                    }
                    self?.isLastPage = newMovies.count < self?.pageSize ?? 20
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func loadNextPageIfNeeded(currentIndex: Int) {
        guard !isLastPage, !isLoading, currentIndex >= movies.count - 5 else { return }
        currentPage += 1
        fetchMovies(reset: false)
    }

    func updateSearchQuery(_ query: String) {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            if self.searchQuery != query {
                self.searchQuery = query
                self.fetchMovies(reset: true)
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
    func toggleFavorite(movieId: Int) {
        favoritesService.toggleFavorite(movieId: movieId)
        onMoviesChanged?()
    }
}
