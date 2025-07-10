//
//  MoviesViewModel.swift
//  MovieExplorer
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation

class MoviesViewModel {
    // MARK: - Properties
    private let getPopularMoviesUseCase: GetPopularMoviesUseCaseProtocol
    
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
    
    // MARK: - Init
    init(getPopularMoviesUseCase: GetPopularMoviesUseCaseProtocol = DIContainer.shared.getPopularMoviesUseCase) {
        self.getPopularMoviesUseCase = getPopularMoviesUseCase
    }
    
    // MARK: - Methods
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
}
