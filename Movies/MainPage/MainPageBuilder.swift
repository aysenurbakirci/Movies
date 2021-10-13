//
//  MainPageBuilder.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 13.10.2021.
//

import Foundation
class MainPageBuilder {
    static func build() -> MainViewController {
        let viewController = MainViewController()
        viewController.mainViewModel = MainViewModel(mainViewService: MainApi())
        viewController.mainViewModel.getPopularMovies()
        return viewController
    }
}
