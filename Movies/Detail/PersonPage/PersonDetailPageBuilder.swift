//
//  PersonDetailPageBuilder.swift
//  Movies
//
//  Created by Mustafa Gunes on 9.11.2021.
//

import Foundation

final class PersonDetailPageBuilder {
    static func build(with id: Int) -> PersonDetailViewController {
        let viewController = PersonDetailViewController(personId: id)
        return viewController
    }
}
