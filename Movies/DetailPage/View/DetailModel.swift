//
//  DetailModel.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 18.10.2021.
//

import Foundation

protocol DetailModelProtocol {
    
    var imagePath: String? { get }
    var title: String { get }
    var subtitle: String? { get }
    var overview: String? { get }
    var link: String? { get }
    var castArray: [HorizontalListModel] { get }
}

struct DetailModel: DetailModelProtocol {
    
    var imagePath: String?
    var title: String
    var subtitle: String?
    var overview: String?
    var link: String?
    var castArray: [HorizontalListModel] = []
    
    init(movie: MovieDetail) {
        
        self.title = movie.title
        self.subtitle = String(movie.voteAverage)
        self.overview = movie.overview
        self.link = movie.trailers.first?.key
        
        for person in movie.cast {
            castArray.append(HorizontalListModel(id: person.id, imagePath: person.profilePath ?? "", title: person.name))
        }
        
        guard let image = movie.backdropPath else { return }
        self.imagePath = image
    }
    
    init(person: PersonDetail) {
        
        self.imagePath = person.profilePath
        self.title = person.name
        self.overview = person.biography
        self.link = nil
        
        for movie in person.movieCredits {
            castArray.append(HorizontalListModel(id: movie.id, imagePath: movie.posterPath ?? "", title: movie.title))
        }
    }
}
