//
//  MovieCellViewModel.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 13.10.2021.
//

import Foundation

struct MovieCellViewModel: MainTableViewCellProtocol {
    
    var image: ImageInfo?
    var title: TextConfiguration
    var subtitle: TextConfiguration?
    var secondSubtitle: TextConfiguration?
    
    init(movie: Movie) {
        
        if let imageURL = movie.posterPath {
            self.image = ImageInfo(urlString: imageURL, width: 500)
        }
        
        self.title = TextConfiguration(title: movie.title, titleFont: nil, titleColor: nil)
        self.subtitle = TextConfiguration(title: movie.releaseDate, titleFont: nil, titleColor: nil)
        self.secondSubtitle = TextConfiguration(title: String(movie.voteAverage), titleFont: nil, titleColor: nil)
    }
    
    init(person: Person) {
        
        if let imageURL = person.profilePath {
            self.image = ImageInfo(urlString: imageURL, width: 500)
        }
        
        self.title = TextConfiguration(title: person.name, titleFont: nil, titleColor: nil)
        self.subtitle = TextConfiguration(title: String(person.popularity), titleFont: nil, titleColor: nil)
    }
}
