//
//  Movies.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import Foundation

public final class Movies: Codable {
    public var page: Int
    public var results: [Movie]
    public let totalPages: Int
    public let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    public func addNewPage(movies: Movies) {
        self.page = movies.page
        self.results.append(contentsOf: movies.results)
    }
}

public extension Movies {
    var hasNextPage: Bool {
        return page < totalPages
    }
}

public struct Movie: Codable {
    public let id: Int
    public let posterPath: String?
    public let releaseDate: String?
    public let title: String
    public let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        let date = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        releaseDate = dateFormatter(input: date ?? "0000-01-00")
        title = try container.decode(String.self, forKey: .title)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        
        func dateFormatter(input: String) -> String{
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            let dateFormatterSet = DateFormatter()
            dateFormatterSet.dateFormat = "dd MMM yyyy"
            if let date = dateFormatterGet.date(from: input) {
                return dateFormatterSet.string(from: date)
            } else {
               return ""
            }
        }
    }
}


