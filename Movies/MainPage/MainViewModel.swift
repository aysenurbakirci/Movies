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

final class MainViewModel {
    
    let data = BehaviorRelay<[Section]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let isEmptyData = BehaviorRelay<Bool>(value: false)
    let loadData = PublishSubject<Void>()
    let searchQuery = BehaviorRelay<String?>(value: nil)
    
    private var popularMovies: Movies?
    
    private let disposeBag = DisposeBag()
    private let mainViewService: MainApiProtocol
    
    private(set) var nextPage = 1
    
    init(mainViewService: MainApiProtocol) {
        self.mainViewService = mainViewService
        
        data.subscribe(onNext: { data in
            if data.count == 1 {
                if data[0].numberOfItems == 0 {
                    self.isEmptyData.accept(true)
                } else {
                    self.isEmptyData.accept(false)
                }
            } else if data.count == 2 {
                if data[0].numberOfItems == 0 && data[1].numberOfItems == 0 {
                    self.isEmptyData.accept(true)
                } else {
                    self.isEmptyData.accept(false)
                }
            }
        })
        .disposed(by: disposeBag)
        
        
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
            .flatMap({ [unowned self] page in
                return self.mainViewService.getPopularMovies(page: page)
            })
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isLoading.accept(false)
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
        
        let searchObservable = searchQuery
            .asObservable()
            .compactMap { $0 }
            .share()
            
        searchObservable
            .filter { !$0.isEmpty }
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isLoading.accept(true)
            })
            .flatMap({ [unowned self] query in
                return self.mainViewService.searchMoviesAndPeople(with: query, page: 1)
            })
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.data.accept([.movie(data.movies), .person(data.people)])
                self.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
        
        searchObservable
            .filter { $0.isEmpty }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.data.accept([.movie(self.popularMovies?.results ?? [])])
                self.isEmptyData.accept(false)
            })
            .disposed(by: disposeBag)
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
    
    func openDetailPage(for indexPath: IndexPath) -> DetailViewController {
        let section = data.value[indexPath.section]
        switch section {
        case .movie(let movies):
            let movie = movies[indexPath.row]
            return DetailPageBuilder.build(movieId: movie.id)
        case .person(let people):
            let person = people[indexPath.row]
            return DetailPageBuilder.build(personId: person.id)
        }
    }
}
