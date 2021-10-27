//
//  PersonDetail.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//
import Foundation

public final class PersonDetail: Codable {
    public let id: Int
    public let name: String
    public let profilePath: String?
    public let biography: String
    
    public var movieCredits: [MovieCredits] = []

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
        case biography
    }
    
    public func addMovieCast(movies: [MovieCredits]) {
        movieCredits.append(contentsOf: movies)
    }
}

public struct PersonMovies: Codable {
    public let cast: [MovieCredits]
}

public struct MovieCredits: Codable {
    public let id: Int
    public let title: String
    public let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
    }
}

