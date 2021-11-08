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
    var loadDataTrigger: Driver<Void> = .never()
    var openMovieTrigger: Driver<Int> = .never()
}

struct PersonDetailViewModelOutput {
    var data: Driver<[PersonViewSections]>
    var isLoading: Driver<Bool>
    var openMovieDetailController: Driver<MovieDetailViewController>
}

func personDetailViewModel(input: PersonDetailViewModelInput) -> PersonDetailViewModelOutput {
    
    let isLoading = BehaviorRelay<Bool>(value: false)
   
    let dataDriver = input.loadDataTrigger
        .asObservable()
        .filter { [isLoading] in
            if isLoading.value {
                return false
            }
            isLoading.accept(true)
            return true
        }
        .compactMap { _ in
            return input.personId
        }
        .flatMap { id in
            return input.detailService.getDetails(personId: id)
        }
        .map({ personDetail in
            return [PersonViewSections.detail(personDetail),
                    PersonViewSections.list(personDetail.movieCredits)]
        })
        .do(onNext: { _ in
            isLoading.accept(false)
        })
        .asDriver(onErrorDriveWith: .never())
    
    let openMovieDetailDriver = input.openMovieTrigger
        .asObservable()
        .map { movieId in
            return MovieDetailViewController(movieId: movieId)
        }
        .asDriver(onErrorDriveWith: .never())
    
    return PersonDetailViewModelOutput(data: dataDriver,
                                       isLoading: isLoading.asDriver(),
                                       openMovieDetailController: openMovieDetailDriver)
}
