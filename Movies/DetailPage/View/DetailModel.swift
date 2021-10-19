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
    var buttonImageName: String? { get }
    var castArray: [HorizontalListModel]? { get }
}

struct DetailModel: DetailModelProtocol {
    
    var image: ImageInfo?
    var title: String
    var subtitle: String?
    var overview: String?
    var buttonImageName: String?
    var castArray: [HorizontalListModel]?
    
    init(movie: MovieDetail) {
        
        self.image = ImageInfo(urlString: movie.backdropPath, width: 500)
        self.title = movie.title
        self.subtitle = String(movie.voteAverage)
        self.overview = movie.overview
        self.buttonImageName = "play.svg"
        
        for i in movie.cast {
            castArray?.append(HorizontalListModel(id: movie.id, imagePath: i.profilePath ?? "", title: i.name))
        }
    }
    
    init(person: PersonDetail) {
        
        self.image = ImageInfo(urlString: person.profilePath, width: 500)
        self.title = person.name
        self.overview = person.biography
        self.buttonImageName = nil
        
    }
}
