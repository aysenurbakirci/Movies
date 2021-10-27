//
//  People.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import Foundation

public struct People: Codable {
    public let results: [Person]
}

public struct Person: Codable {
    public let id: Int
    public let name: String
    public let popularity: Double
    public let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case popularity
        case profilePath = "profile_path"
    }
}

