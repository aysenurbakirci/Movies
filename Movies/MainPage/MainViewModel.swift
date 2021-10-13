//
//  MainViewModel.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 12.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol MainViewModelProtocol {
    func getPopularMovies()
    func searchMovieAndActor(searchQuery: String)
}

final class MainViewModel {
    
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
                self.popularMoviesRelay.accept(movieList)
            }).disposed(by: disposeBag)
    }
    
    func searchMovieAndActor(searchQuery: String) {
        
        mainViewService
            .searchMoviesAndPersons(query: searchQuery)
            .subscribe(onNext: { [weak self] searchedData in
                guard let self = self else { return }
                self.searchMovieAndActorRelay.accept(searchedData)
            }).disposed(by: disposeBag)
    }
}
