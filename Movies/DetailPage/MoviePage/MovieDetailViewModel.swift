//
//  MovieDetailViewModel.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 25.10.2021.
//

import RxSwift
import RxCocoa
import ImdbAPI

enum MovieViewSections {
    case detail(MovieDetail), list([Cast])
}

final class MovieDetailViewModel {
    let data = BehaviorRelay<[MovieViewSections]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    
    private let movieId: Int
    private let detailService: DetailApiProtocol
    private let disposeBag = DisposeBag()
    
    init(movieId: Int, service: DetailApiProtocol) {
        self.detailService = service
        self.movieId = movieId
    }
    
    func getDetails() {
        Observable.just(())
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
                guard let self = self else { return 0 }
                return self.movieId
            }
            .flatMap { [unowned self] id in
                return self.detailService.getDetails(movieId: id)
            }
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isLoading.accept(false)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.isLoading.accept(false)
            })
            .subscribe(onNext: { [weak self] movie in
                guard let self = self else { return }
                self.data.accept([.detail(movie), .list(movie.cast)])
                self.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func openPersonPage(id: Int) -> PersonDetailViewController {
        return PersonDetailPageBuilder.build(personId: id)
    }
    
    func openLink(key: String) {
        let url = detailService.createTrailerUrl(key: key)
        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
         }
    }
}
