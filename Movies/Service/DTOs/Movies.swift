//
//  Movies.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import Foundation

class Movies: Codable {
    var page: Int
    var results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    func addNewPage(movies: Movies) {
        self.page = movies.page
        self.results.append(contentsOf: movies.results)
    }
}

extension Movies {
    var hasNextPage: Bool {
        return page < totalPages
    }
}

struct Movie: Codable {
    let id: Int
    let posterPath: String?
    let releaseDate: String?
    let title: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
    
    init(from decoder: Decoder) throws {
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


