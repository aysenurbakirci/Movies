//
//  HorizontalListModel.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 18.10.2021.
//

import Foundation
import MoviesAPI

struct HorizontalListModel {
    var id: Int
    var imagePath: String
    var title: String
}

struct ListModel {
    var castArray: [HorizontalListModel] = []
    
    init(movieCast: [Cast]) {
        
        for person in movieCast {
            castArray.append(HorizontalListModel(id: person.id, imagePath: person.profilePath ?? "", title: person.name))
        }
    }
    
    init(personMovies: [MovieCredits]) {
        
        for movie in personMovies {
            castArray.append(HorizontalListModel(id: movie.id, imagePath: movie.posterPath ?? "", title: movie.title))
        }
    }
}
