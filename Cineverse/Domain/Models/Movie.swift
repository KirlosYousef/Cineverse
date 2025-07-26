//
//  Movie.swift
//  Cineverse
//
//  Created by Kirlos Yousef on 09/07/2025.
//

import Foundation

/// Movie model representing a movie from TMDB API.
struct Movie: Equatable, Codable, Identifiable {
    /// The unique identifier for the movie.
    let id: Int
    /// The title of the movie.
    let title: String
    /// The overview or description of the movie.
    let overview: String
    /// The path to the movie's poster image, if available.
    let posterPath: String?
    /// The release date of the movie (format: yyyy-MM-dd).
    let releaseDate: String
    /// The average user rating for the movie.
    let voteAverage: Double
    
    /// Coding keys for mapping JSON keys to struct properties.
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    
    /// The full URL for the movie's poster image, or nil if not available.
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
} 
