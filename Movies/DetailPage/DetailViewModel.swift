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
    func openNewDetailPage(id: Int) -> DetailViewController

}

final class MovieDetailViewModel: DetailViewModelProtocol {
    
    var data = BehaviorRelay<DetailModel?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var loadData = PublishSubject<Void>()
    
    private let movieId: Int
    private let detailService: DetailApiProtocol
    private let disposeBag = DisposeBag()
    
    init(movieId: Int, service: DetailApiProtocol) {
        self.detailService = service
        self.movieId = movieId
        getDetails(id: movieId)
    }
    
    func getDetails(id: Int) {
        loadData
            .filter { [weak isLoading] in
                guard let isLoading = isLoading else { return false }
                
                if isLoading.value {
                    return false
                }
                isLoading.accept(true)
                return true
            }
            .compactMap { [weak self] in
                return self?.movieId
            }
            .flatMap ({ [unowned self] id in
                return self.detailService.getDetails(movieId: id)
            })
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
    
    func openNewDetailPage(id: Int) -> DetailViewController {
        return DetailPageBuilder.build(personId: id)
    }
}

final class PersonDetailViewModel: DetailViewModelProtocol {

    var data = BehaviorRelay<DetailModel?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    var loadData = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
    private let personId: Int
    private let detailService: DetailApiProtocol
    
    init(personId: Int, service: DetailApiProtocol) {
        self.personId = personId
        self.detailService = service
        getDetails(id: personId)
    }
    
    func getDetails(id: Int) {
        
        loadData
            .filter { [weak isLoading] in
                guard let isLoading = isLoading else { return false }
                if isLoading.value {
                    return false
                }
                isLoading.accept(true)
                return true
            }
            .compactMap { [weak self] in
                return self?.personId
            }
            .flatMap ({ [unowned self] id in
                return self.detailService.getDetails(personId: id)
            })
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.isLoading.accept(false)
            })
            .subscribe(onNext: { [weak self] person in
                let detailModel = DetailModel(person: person)
                self?.data.accept(detailModel)
            })
            .disposed(by: disposeBag)
    }
    
    func openNewDetailPage(id: Int) -> DetailViewController {
        return DetailPageBuilder.build(movieId: id)
    }
}
