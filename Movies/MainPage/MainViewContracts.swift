//
//  MainViewContracts.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 14.10.2021.
//

import Foundation

enum Section {
    
    case movie([Movie]), person([Person])
    
    var numberOfItems: Int {
        switch self {
        case .movie(let movies):
            return movies.count
        case .person(let people):
            return people.count
        }
    }
}
