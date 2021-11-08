//
//  MainViewModel.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 12.10.2021.
//

import Foundation
import RxSwift
import RxCocoa
import ImdbAPI
import Utils

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

final class MainViewModel: ActivityHandler {

    var onError = BehaviorRelay<Error?>(value: nil)
    let isLoading = BehaviorRelay<Bool>(value: false)
    let isEmptyData = BehaviorRelay<Bool>(value: false)
    
    let data = BehaviorRelay<[Section]>(value: [])
    let loadData = PublishSubject<Void>()
    let searchQuery = BehaviorRelay<String?>(value: nil)
    
    private var popularMovies: Movies?
    
    private let disposeBag = DisposeBag()
    private let mainViewService: MainApiProtocol
    
    private(set) var nextPage = 1
    
    init(mainViewService: MainApiProtocol) {
        self.mainViewService = mainViewService
        
        loadData
            .filter({ [weak self] in
                return self?.popularMovies?.hasNextPage ?? true
            })
            .filter { [weak isLoading] in
                guard let isLoading = isLoading else {
                    return false
                }
                if isLoading.value {
                    return false
                }
                isLoading.accept(true)
                return true
            }
            .compactMap({ [weak self] in
                return self?.nextPage
            })
            .flatMap({ [unowned self] page in
                return self.mainViewService.getPopularMovies(page: page)
            })
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isLoading.accept(false)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.isLoading.accept(false)
                self.onError.accept(error)
            })
            .retry(3)
            .subscribe(onNext: { [weak self] movies in
                guard let self = self else { return }
                if movies.results.isEmpty {
                    self.isEmptyData.accept(true)
                    return
                }
                self.isEmptyData.accept(false)
                if self.popularMovies == nil {
                    self.popularMovies = movies
                } else {
                    self.popularMovies?.addNewPage(movies: movies)
                }
                self.data.accept([.movie(self.popularMovies?.results ?? [])])
                self.nextPage += 1
                print("nextPage: \(self.nextPage)")
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
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isLoading.accept(false)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.isLoading.accept(false)
                self.onError.accept(error)
            })
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                if data.movies.isEmpty && data.people.isEmpty {
                    self.isEmptyData.accept(true)
                    return
                }
                self.isEmptyData.accept(false)
                self.data.accept([.movie(data.movies), .person(data.people)])
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
    
    func openDetailPage(for indexPath: IndexPath) -> UIViewController {
        let section = data.value[indexPath.section]
        switch section {
        case .movie(let movies):
            let movie = movies[indexPath.row]
            return MovieDetailViewController(movieId: movie.id)
        case .person(let people):
            let person = people[indexPath.row]
            return PersonDetailViewController(personId: person.id)
        }
    }
}
