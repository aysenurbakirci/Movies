//
//  MainViewModel.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 12.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

enum Section {
    case movie([Movie]), person([Actor])
    
    var numberOfItems: Int {
        switch self {
        case .movie(let movies):
            return movies.count
        case .person(let people):
            return people.count
        }
    }
}

protocol MainViewModelProtocol {
    func getPopularMovies()
    func searchMovieAndActor(searchQuery: String)
}

final class MainViewModel: MainViewModelProtocol {
    
    let data = BehaviorRelay<[Section]>(value: [])
    
    private var popularMovies = [Movie]()
    let popularMoviesRelay = BehaviorRelay<[Movie]>(value: [])
    let searchMovieAndActorRelay = BehaviorRelay<(movies: [Movie], persons: [Actor])>(value: (movies: [], persons: []))
    
    private let disposeBag = DisposeBag()
    private let mainViewService: MainApiProtocol
    
    init(mainViewService: MainApiProtocol) {
        self.mainViewService = mainViewService
    }
    
    func getPopularMovies() {
        
        mainViewService
            .getPopularMovies()
            .subscribe(onNext: { [weak self] movieList in
                guard let self = self else { return }
                self.popularMovies = movieList
                self.data.accept([.movie(movieList)])
            }).disposed(by: disposeBag)
    }
    
    func searchMovieAndActor(searchQuery: String) {
        
        if searchQuery.isEmpty {
            self.data.accept([.movie(popularMovies)])
            return
        }
        
        mainViewService
            .searchMoviesAndPersons(query: searchQuery)
            .subscribe(onNext: { [weak self] searchedData in
                guard let self = self else { return }
                self.data.accept([.movie(searchedData.movies), .person(searchedData.persons)])
            }).disposed(by: disposeBag)
    }
    
    func viewModel(for indexPath: IndexPath) -> MainTableViewCellProtocol {
        
        let section = data.value[indexPath.section]
        switch section {
        case .movie(let movies):
            let movie = movies[indexPath.row]
            return MovieCellViewModel(movie: movie)
        case .person(let people):
            let person = people[indexPath.row]
            return MovieCellViewModel(actor: person)
        }
    }
}
