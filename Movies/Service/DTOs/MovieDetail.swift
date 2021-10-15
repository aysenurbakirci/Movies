//
//  MovieDetail.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import Foundation

class MovieDetail: Codable {
    let id: Int
    let backdropPath: String
    let overview: String
    let title: String
    let voteAverage: Double
    
    var cast: [Cast] = []
    var trailers: [Trailer] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case backdropPath = "backdrop_path"
        case overview
        case title
        case voteAverage = "vote_average"
    }
    
    func addMovieCast(movieCast: MovieCast) {
        cast.append(contentsOf: movieCast.cast)
    }
    
    func addTrailers(movieTrailer: MovieTrailers) {
        trailers.append(contentsOf: movieTrailer.results)
    }
    
}

struct MovieCast: Codable {
    let cast: [Cast]
}

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

struct MovieTrailers: Codable {
    let results: [Trailer]
}

struct Trailer: Codable {
    let key: String
    let site: String

}



