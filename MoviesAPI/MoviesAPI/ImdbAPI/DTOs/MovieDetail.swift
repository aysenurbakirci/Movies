//
//  MovieDetail.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import Foundation

public class MovieDetail: Codable {
    public let id: Int
    public let backdropPath: String?
    public let overview: String
    public let title: String
    public let voteAverage: Double
    
    public var cast: [Cast] = []
    public var trailers: [Trailer] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case backdropPath = "backdrop_path"
        case overview
        case title
        case voteAverage = "vote_average"
    }
    
    public func addMovieCast(movieCast: MovieCast) {
        cast.append(contentsOf: movieCast.cast)
    }
    
    public func addTrailers(movieTrailer: MovieTrailers) {
        trailers.append(contentsOf: movieTrailer.results)
    }
}

public struct MovieCast: Codable {
    public let cast: [Cast]
}

public struct Cast: Codable {
    public let id: Int
    public let name: String
    public let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
    }
}

public struct MovieTrailers: Codable {
    public let results: [Trailer]
}

public struct Trailer: Codable {
    public let key: String
    public let site: String
}
