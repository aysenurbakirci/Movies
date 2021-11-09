//
//  MoviewDetailPageBuilder.swift
//  Movies
//
//  Created by Mustafa Gunes on 9.11.2021.
//

import Foundation

final class MovieDetailPageBuilder {
    static func build(with id: Int) -> MovieDetailViewController {
        let viewController = MovieDetailViewController(movieId: id)
        return viewController
    }
}
