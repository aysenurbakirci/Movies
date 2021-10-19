//
//  DetailViewModel.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 18.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol DetailViewModelProtocol {
    
    var data: BehaviorRelay<DetailModel?> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var loadData: PublishSubject<Void> { get }
    func getDetails(id: Int)

}

class MovieDetailViewModel: DetailViewModelProtocol {
    
    var data = BehaviorRelay<DetailModel?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var loadData = PublishSubject<Void>()
    
    private let movieId: Int
    private let detailService: DetailApiProtocol = DetailApi()
    private let disposeBag = DisposeBag()
    
    init(movieId: Int) {
        self.movieId = movieId
        getDetails(id: movieId)
    }
    
    func getDetails(id: Int) {
        loadData
            .filter { [isLoading] in
                if isLoading.value {
                    return false
                }
                self.isLoading.accept(true)
                return true
            }
            .compactMap { [weak self] in
                return self?.movieId
            }
            .flatMap(getMovie)
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.isLoading.accept(false)
            })
            .subscribe(onNext: { [weak self] movie in
                guard let self = self else { return }
                let detailModel = DetailModel.init(movie: movie)
                self.data.accept(detailModel)
            })
            .disposed(by: disposeBag)
    }
    
    private func getMovie(movieId: Int) -> Observable<MovieDetail> {
        return detailService.getDetails(with: movieId)
    }
}

class PersonDetailViewModel: DetailViewModelProtocol {
    
    var data = BehaviorRelay<DetailModel?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var loadData = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
    private let personId: Int
    private let detailService: DetailApiProtocol = DetailApi()
    
    init(personId: Int) {
        self.personId = personId
        getDetails(id: personId)
    }
    
    func getDetails(id: Int) {
        
        loadData
            .filter { [isLoading] in
                if isLoading.value {
                    return false
                }
                self.isLoading.accept(true)
                return true
            }
            .compactMap { [weak self] in
                return self?.personId
            }
            .flatMap(getPerson)
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.isLoading.accept(false)
            })
            .subscribe(onNext: { [weak self] person in
                let detailModel = DetailModel.init(person: person)
                self?.data.accept(detailModel)
            })
            .disposed(by: disposeBag)
    }
    
    private func getPerson(personId: Int) -> Observable<PersonDetail> {
        return detailService.getDetails(with: personId)
    }
    
}
