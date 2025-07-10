//
//  MovieDetailsViewModel.swift
//  MovieExplorer
//
//  Created by Kirlos Yousef on 10/07/2025.
//

import Foundation

class MovieDetailsViewModel {
    private let movie: Movie
    
    var title: String { movie.title }
    var overview: String { movie.overview }
    var releaseDate: String { movie.releaseDate }
    var posterURL: URL? { movie.posterURL }
    
    init(movie: Movie) {
        self.movie = movie
    }
} 
