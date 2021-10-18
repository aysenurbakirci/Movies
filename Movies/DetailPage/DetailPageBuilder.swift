//
//  DetailPageBuilder.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 18.10.2021.
//

import Foundation

final class DetailPageBuilder {
    static func build() -> DetailViewController {
        let viewController = DetailViewController()
        viewController.detailViewModel = DetailViewModel(movieId: 0)
        return viewController
    }
}
