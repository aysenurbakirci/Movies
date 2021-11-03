//
//  MainTableViewCellViewModel.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 13.10.2021.
//

import Foundation
import ImdbAPI

protocol MainTableViewCellProtocol {
    var imagePath: String? { get }
    var title: String { get }
    var subtitle: String? { get }
    var secondSubtitle: String? { get }
}

struct CellViewModel: MainTableViewCellProtocol {
    
    var imagePath: String?
    var title: String
    var subtitle: String?
    var secondSubtitle: String?
    
    init(movie: Movie) {
        
        if let imageURL = movie.posterPath {
            self.imagePath = imageURL
        }
        if let releaseDate = movie.releaseDate {
            self.subtitle = releaseDate
        }
        self.title = movie.title
        self.secondSubtitle = String(movie.voteAverage)
    }
    
    init(person: Person) {
        
        if let imageURL = person.profilePath {
            self.imagePath = imageURL
        }
        
        self.title = person.name
        self.subtitle = String(person.popularity)
    }
}
