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
    
    private var popularMovies = [Movie]()
    
    private let disposeBag = DisposeBag()
    private let mainViewService: MainApiProtocol
    
    weak var delegate: MainViewModelDelegate?
    
    private var currentPage = 1
    var isFetching = false
    
    init(mainViewService: MainApiProtocol) {
        self.mainViewService = mainViewService
    }
    
    func getPopularMovies() {
        delegate?.startLoading()
        mainViewService
            .getPopularMovies(page: 1)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movieList in
                guard let self = self else { return }
                self.popularMovies = movieList
                self.data.accept([.movie(movieList)])
                self.delegate?.reloadTableViewData()
                self.delegate?.stopLoading()
            }).disposed(by: disposeBag)
    }
    
    func searchMovieAndPerson(searchQuery: String) {
        
        if searchQuery.isEmpty {
            self.data.accept([.movie(popularMovies)])
            return
        }
        mainViewService
            .searchMoviesAndPeople(with: searchQuery, page: 1)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] searchedData in
                guard let self = self else { return }
                self.data.accept([.movie(searchedData.movies), .person(searchedData.people)])
                self.delegate?.reloadTableViewData()
            }).disposed(by: disposeBag)
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
    
    func fetchOtherPages() {
        isFetching = true
        mainViewService
            .getPopularMovies(page: currentPage)
            .subscribe(onNext: { [weak self] movieList in
                guard let self = self else { return }
                self.popularMovies += movieList
                self.data.accept([.movie(self.popularMovies)])
                print("PAGE: \(self.currentPage)")
                self.isFetching = false
                self.currentPage += 1
            }).disposed(by: disposeBag)
    }
}

extension MainViewModel: MainViewModelProtocol {
    
    func numberOfRowsInSection(for section: Int) -> Int {
        data.value[section].numberOfItems
    }
    
    var numberOfSections: Int {
        data.value.count
    }
    
}
