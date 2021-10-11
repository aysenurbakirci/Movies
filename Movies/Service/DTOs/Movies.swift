//
//  Movies.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import Foundation

// MARK: - Movie List
struct Movies: Codable {
    let results: [Movie]
}

// MARK: - Movie
struct Movie: Codable {
    let id: Int
    let posterPath: String
    let releaseDate: String
    let title: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}
