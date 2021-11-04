//
//  DetailViewModel.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 18.10.2021.
//

import Foundation
import RxSwift
import RxCocoa
import ImdbAPI

enum PersonViewSections {
    case detail(PersonDetail), list([MovieCredits])
}

struct PersonDetailViewModelInput {
    var personId: Int
    var detailService: DetailApiProtocol
    var loadDataTrigger: Driver<Void>
    var openMovieTrigger: Driver<Int>
}

struct PersonDetailViewModelOutput {
    var data: Driver<[PersonViewSections]>
    var isLoading: Driver<Bool>
    var openMovieDetailController: Driver<MovieDetailViewController>
}

final class PersonDetailViewModel {
    
    //Outputs
    private(set) var data = BehaviorRelay<[PersonViewSections]>(value: [])
    private(set) var isLoading = BehaviorRelay<Bool>(value: false)
    
    //Inputs
    private let personId: Int
    private let detailService: DetailApiProtocol
    private var loadDataTrigger: Driver<Void>
    private var openMovieTrigger: Driver<Int>
    
    private let disposeBag = DisposeBag()

    init(input: PersonDetailViewModelInput) {
        self.personId = input.personId
        self.detailService = input.detailService
        self.loadDataTrigger = input.loadDataTrigger
        self.openMovieTrigger = input.openMovieTrigger
    }
    
    func transform() -> PersonDetailViewModelOutput {
        loadDataTrigger
            .asObservable()
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
            .compactMap { [weak self] in
                return self?.personId
            }
            .flatMap ({ [unowned self] id in
                return self.detailService.getDetails(personId: id)
            })
            .subscribe(onNext: { [weak self] person in
                guard let self = self else { return }
                self.data.accept([.detail(person), .list(person.movieCredits)])
                self.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
        
        let openMovieDetailDriver = openMovieTrigger
            .asObservable()
            .map { movieId in
                return MovieDetailViewController(movieId: movieId)
            }
            .asDriver(onErrorDriveWith: .never())
        
        return PersonDetailViewModelOutput(data: self.data.asDriver(),
                                           isLoading: self.isLoading.asDriver(),
                                           openMovieDetailController: openMovieDetailDriver)
    }
}
