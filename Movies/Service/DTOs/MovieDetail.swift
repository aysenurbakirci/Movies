//
//  MovieDetail.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import Foundation

// MARK: - MovieDetail
struct MovieDetail: Codable {
    let id: Int
    let backdropPath: String
    let overview: String
    let title: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id
        case backdropPath = "backdrop_path"
        case overview
        case title
        case voteAverage = "vote_average"
    }
}

// MARK: - MovieCast
struct MovieCast: Codable {
    let cast: [Cast]
}

// MARK: - Cast
struct Cast: Codable {
    let id: Int
    let name: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
    }
}


// MARK: - MovieTrailers
struct MovieTrailers: Codable {
    let results: [Trailer]
}

// MARK: - Trailer
struct Trailer: Codable {
    let key: String
    let site: String

}



