//
//  PersonDetail.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//
import Foundation

struct PersonDetail: Codable {
    let id: Int
    let name: String
    let profilePath: String
    let biography: String
    let homepage: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
        case biography
        case homepage
    }
}

import Foundation

struct PersonMovies: Codable {
    let cast: [MovieCredits]
}

struct MovieCredits: Codable {
    let id: Int
    let title: String
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
    }
}

