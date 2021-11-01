//
//  DetailViewModel.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 18.10.2021.
//

import Foundation
import RxSwift
import RxCocoa
import MoviesAPI

enum PersonViewSections {
    case detail(PersonDetail), list([MovieCredits])
}

final class PersonDetailViewModel {
    var data = BehaviorRelay<[PersonViewSections]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    
    private let personId: Int
    private let detailService: DetailApiProtocol
    private let disposeBag = DisposeBag()
    
    init(personId: Int, service: DetailApiProtocol) {
        self.personId = personId
        self.detailService = service
    }
    
    func getDetails() {
        
        Observable.just(())
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
                guard let self = self else { return }
                self.isLoading.accept(false)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.isLoading.accept(false)
            })
            .subscribe(onNext: { [weak self] person in
                guard let self = self else { return }
                self.data.accept([.detail(person), .list(person.movieCredits)])
                self.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func openMoviePage(id: Int) -> MovieDetailViewController {
        return MovieDetailPageBuilder.build(movieId: id)
    }
}
