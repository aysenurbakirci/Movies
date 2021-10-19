//
//  DetailPageBuilder.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 18.10.2021.
//

import Foundation

final class DetailPageBuilder {
    static func build(viewModel: DetailViewModelProtocol) -> DetailViewController {
        let viewController = DetailViewController()
        viewController.detailViewModel = viewModel
        return viewController
    }
}
