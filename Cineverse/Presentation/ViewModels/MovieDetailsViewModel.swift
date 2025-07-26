//
//  MovieDetailsViewModel.swift
//  Cineverse
//
//  Created by Kirlos Yousef on 10/07/2025.
//

import Foundation

/// View model for presenting details of a single movie.
class MovieDetailsViewModel {
    private let movie: Movie
    
    /// The title of the movie.
    var title: String { movie.title }
    /// The overview or description of the movie.
    var overview: String { movie.overview }
    /// The release date of the movie.
    var releaseDate: String { movie.releaseDate }
    /// The URL for the movie's poster image, if available.
    var posterURL: URL? { movie.posterURL }
    
    /// Initializes the view model with a movie.
    ///
    /// - Parameter movie: The movie to present details for.
    init(movie: Movie) {
        self.movie = movie
    }
} 
