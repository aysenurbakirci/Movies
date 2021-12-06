//
//  DetailViewModel.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 18.10.2021.
//

import RxSwift
import RxCocoa
import ImdbAPI

enum PersonViewSections {
    case detail(PersonDetail), list([MovieCredits])
}

struct PersonDetailViewModelInput {
    var personId: Int
    var detailService: DetailApiProtocol
    var loadDataTrigger: BehaviorRelay<Void>
}

struct PersonDetailViewModelOutput {
    var data: Driver<[PersonViewSections]>
    var isLoading: Driver<Bool>
    var onError: Driver<Error?>
}

func personDetailViewModel(input: PersonDetailViewModelInput) -> PersonDetailViewModelOutput {
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    let onError = PublishRelay<Error?>()
   
    let dataDriver = input.loadDataTrigger
        .do(onNext: { _ in
            isLoading.accept(true)
        })
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
        }, onError: { error in
            onError.accept(error)
            isLoading.accept(false)
        })
        .asDriver(onErrorDriveWith: .never())
    
    return PersonDetailViewModelOutput(data: dataDriver,
                                       isLoading: isLoading.asDriver(),
                                       onError: onError.asDriver(onErrorDriveWith: .never()))
}
