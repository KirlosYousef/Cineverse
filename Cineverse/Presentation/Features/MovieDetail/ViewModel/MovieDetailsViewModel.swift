//
//  MovieDetailsViewModel.swift
//  Cineverse
//
//  Created by Kirlos Yousef on 10/07/2025.
//

import Foundation
import Combine

/// View model for presenting details of a single movie.
/// Conforms to ObservableObject to work with SwiftUI.
@MainActor
class MovieDetailsViewModel: ObservableObject {
    let movie: Movie
    
    /// The title of the movie.
    var title: String { movie.title }
    /// The overview or description of the movie.
    var overview: String { movie.overview }
    /// The release date of the movie.
    var releaseDate: String { movie.releaseDate }
    /// The URL for the movie's poster image, if available.
    var posterURL: URL? { movie.posterURL }
    
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    
    /// Initializes the view model with a movie.
    ///
    /// - Parameter movie: The movie to present details for.
    init(movie: Movie) {
        self.movie = movie
    }
    
    /// Updates the loading state.
    /// - Parameter isLoading: Whether the view model is currently loading.
    func setLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    /// Updates the error message.
    /// - Parameter errorMessage: The error message to display, or nil to clear the error.
    func setError(_ errorMessage: String?) {
        self.errorMessage = errorMessage
    }
} 
