//
//  MainTableViewCellViewModel.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 13.10.2021.
//

import Foundation

protocol MainTableViewCellProtocol {
    var image: ImageInfo? { get }
    var title: String { get }
    var subtitle: String? { get }
    var secondSubtitle: String? { get }
}

struct CellViewModel: MainTableViewCellProtocol {
    
    var image: ImageInfo?
    var title: String
    var subtitle: String?
    var secondSubtitle: String?
    
    init(movie: Movie) {
        
        if let imageURL = movie.posterPath {
            self.image = ImageInfo(urlString: imageURL, width: 500)
        }
        if let releaseDate = movie.releaseDate {
            self.subtitle = releaseDate
        }
        self.title = movie.title
        self.secondSubtitle = String(movie.voteAverage)
    }
    
    init(person: Person) {
        
        if let imageURL = person.profilePath {
            self.image = ImageInfo(urlString: imageURL, width: 500)
        }
        
        self.title = person.name
        self.subtitle = String(person.popularity)
    }
}
