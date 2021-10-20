//
//  DetailPageBuilder.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 18.10.2021.
//

import Foundation

final class DetailPageBuilder {
    static func build(movieId: Int) -> DetailViewController {
        let viewController = DetailViewController()
        viewController.detailViewModel = MovieDetailViewModel(movieId: movieId, service: DetailApi())
        return viewController
    }
    static func build(personId: Int) -> DetailViewController {
        let viewController = DetailViewController()
        viewController.detailViewModel = PersonDetailViewModel(personId: personId, service: DetailApi())
        return viewController
    }
}
