//
//  DetailViewModel.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 18.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class PersonDetailViewModel {
    
    var data = BehaviorRelay<PersonDetail?>(value: nil)
    var isLoading = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    private let personId: Int
    private let detailService: DetailApiProtocol
    
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
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.data.accept(data)
                self.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func openMoviePage(id: Int) -> MovieDetailViewController {
        return MovieDetailPageBuilder.build(movieId: id)
    }
}
