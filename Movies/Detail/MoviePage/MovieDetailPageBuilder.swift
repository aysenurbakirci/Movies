//
//  MovieDetailPageBuilder.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 25.10.2021.
//

import Foundation

final class MovieDetailPageBuilder {
    
    static func build(movieId: Int) -> MovieDetailViewController {
        let viewController = MovieDetailViewController()
        viewController.viewModel = MovieDetailViewModel(movieId: movieId, service: DetailApi())
        return viewController
    }
}
