//
//  DetailModel.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 18.10.2021.
//

import Foundation

protocol DetailModelProtocol {
    var image: ImageInfo? { get }
    var title: String { get }
    var subtitle: String? { get }
    var overview: String? { get }
    var castArray: [HorizontalArrayModel]? { get }
}

struct DetailModel: DetailModelProtocol {
    
    var image: ImageInfo?
    var title: String
    var subtitle: String?
    var overview: String?
    var castArray: [HorizontalArrayModel]?
    
    init(movie: MovieDetail) {
        
        self.image = ImageInfo(urlString: movie.backdropPath, width: 500)
        self.title = movie.title
        self.subtitle = String(movie.voteAverage)
        self.overview = movie.overview
        
        for i in movie.cast {
            castArray?.append(HorizontalArrayModel(id: movie.id, imagePath: i.profilePath ?? "", title: i.name))
        }
    }
    
    init(person: PersonDetail) {
        
        self.image = ImageInfo(urlString: person.profilePath, width: 500)
        self.title = person.name
        self.overview = person.biography
        
    }
}