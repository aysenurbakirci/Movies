//
//  PersonDetailPageBuilder.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 18.10.2021.
//

import Foundation

final class PersonDetailPageBuilder {
    static func build(personId: Int) -> PersonDetailViewController {
        let viewController = PersonDetailViewController()
        viewController.viewModel = PersonDetailViewModel(personId: personId, service: DetailApi())
        return viewController
    }
}
