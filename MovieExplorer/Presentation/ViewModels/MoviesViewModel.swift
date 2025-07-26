//
//  MoviesViewModel.swift
//  MovieExplorer
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
    
    // MARK: - Methods
    /// Fetches the list of popular movies and updates the state accordingly.
    func fetchMovies() {
        isLoading = true
        errorMessage = nil
        getPopularMoviesUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let movies):
                    self?.movies = movies
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
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
    func toggleFavorite(movieId: Int) {
        favoritesService.toggleFavorite(movieId: movieId)
        onMoviesChanged?()
    }
}
