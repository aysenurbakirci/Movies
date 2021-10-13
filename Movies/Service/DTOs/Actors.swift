//
//  People.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import Foundation

struct People: Codable {
    let results: [Person]
}

struct Person: Codable {
    let id: Int
    let name: String
    let popularity: Double
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case popularity
        case profilePath = "profile_path"
    }
}

