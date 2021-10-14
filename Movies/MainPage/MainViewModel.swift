//
//  MainViewModel.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 12.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel {
    
    let data = BehaviorRelay<[Section]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let loadData = PublishSubject<Void>()
    let searchQuery = BehaviorRelay<String?>(value: nil)
    
    private var popularMovies: Movies?
    
    private let disposeBag = DisposeBag()
    private let mainViewService: MainApiProtocol
    
    private var nextPage = 1
    
    init(mainViewService: MainApiProtocol) {
        self.mainViewService = mainViewService
        
        loadData
            .filter({ [weak self] in
                return self?.popularMovies?.hasNextPage ?? true
            })
            .filter({ [isLoading] in
                if isLoading.value {
                    return false
                }
                self.isLoading.accept(true)
                return true
            })
            .compactMap({ [weak self] in
                return self?.nextPage
            })
            .flatMap(getPopularMovies)
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.isLoading.accept(false)
            })
            .subscribe(onNext: { [weak self] movies in
                guard let self = self else { return }
                if self.popularMovies == nil {
                    self.popularMovies = movies
                } else {
                    self.popularMovies?.addNewPage(movies: movies)
                }
                self.data.accept([.movie(self.popularMovies?.results ?? [])])
                self.nextPage += 1
            })
            .disposed(by: disposeBag)
        
        searchQuery
            .asObservable()
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .do(onNext: { [weak self] _ in
                self?.isLoading.accept(true)
            })
            .flatMap(searchMovieAndPerson)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.data.accept([.movie(data.movies), .person(data.people)])
                self?.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    private func getPopularMovies(nextPage: Int) -> Observable<Movies> {
        return mainViewService.getPopularMovies(page: nextPage)
    }
    
    private func searchMovieAndPerson(searchQuery: String) -> Observable<(movies: [Movie], people: [Person])> {
        return mainViewService.searchMoviesAndPeople(with: searchQuery, page: 1)
    }
    
    func createCellViewModel(for indexPath: IndexPath) -> MainTableViewCellProtocol {
        
        let section = data.value[indexPath.section]
        switch section {
        case .movie(let movies):
            let movie = movies[indexPath.row]
            return CellViewModel(movie: movie)
        case .person(let people):
            let person = people[indexPath.row]
            return CellViewModel(person: person)
        }
    }
}

extension MainViewModel {

    func numberOfRowsInSection(section: Int) -> Int {
        data.value[section].numberOfItems
    }
    
    var numberOfSections: Int {
        data.value.count
    }
    
}
