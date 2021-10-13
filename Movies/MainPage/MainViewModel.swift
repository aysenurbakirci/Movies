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

protocol MainViewModelProtocol {
    func getPopularMovies(page: Int)
    func searchMovieAndPerson(searchQuery: String)
}

final class MainViewModel: MainViewModelProtocol {
    
    let data = BehaviorRelay<[Section]>(value: [])
    
    private var popularMovies = [Movie]()
    
    private let disposeBag = DisposeBag()
    private let mainViewService: MainApiProtocol
    
    init(mainViewService: MainApiProtocol) {
        self.mainViewService = mainViewService
    }
    
    func getPopularMovies(page: Int) {
        
        mainViewService
            .getPopularMovies(page: page)
            .subscribe(onNext: { [weak self] movieList in
                guard let self = self else { return }
                self.popularMovies += movieList
                self.data.accept([.movie(self.popularMovies)])
            }).disposed(by: disposeBag)
    }
    
    func searchMovieAndPerson(searchQuery: String) {
        
        if searchQuery.isEmpty {
            self.data.accept([.movie(popularMovies)])
            return
        }
        
        mainViewService
            .searchMoviesAndPeople(query: searchQuery)
            .subscribe(onNext: { [weak self] searchedData in
                guard let self = self else { return }
                self.data.accept([.movie(searchedData.movies), .person(searchedData.people)])
            }).disposed(by: disposeBag)
    }
    
    func createCellViewModel(for indexPath: IndexPath) -> MainTableViewCellProtocol {
        
        let section = data.value[indexPath.section]
        switch section {
        case .movie(let movies):
            let movie = movies[indexPath.row]
            return MovieCellViewModel(movie: movie)
        case .person(let people):
            let person = people[indexPath.row]
            return PersonCellViewModel(person: person)
        }
    }
}
