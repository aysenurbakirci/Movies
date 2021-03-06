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

struct MovieDetailViewModelInput {
    var movieId: Int
    var detailService: DetailApiProtocol
    var loadDataTrigger: Driver<Void>
    var openLinkTrigger: Driver<String>
}

struct MovieDetailViewModelOutput {
    var data: Driver<[MovieViewSections]>
    var isLoading: Driver<Bool>
    var onError: Driver<Error?>
}

final class MovieDetailViewModel {
    
    //MARK: - Outputs
    private var data = BehaviorRelay<[MovieViewSections]>(value: [])
    private var isLoading = BehaviorRelay<Bool>(value: false)
    private var onError = PublishRelay<Error?>()
    
    //MARK: - Inputs
    private let movieId: Int
    private let detailService: DetailApiProtocol
    private var loadDataTrigger: Driver<Void>
    private var openLinkTrigger: Driver<String>
    
    private let disposeBag = DisposeBag()

    //MARK: - Initalization
    init(input: MovieDetailViewModelInput) {
        self.movieId = input.movieId
        self.detailService = input.detailService
        self.loadDataTrigger = input.loadDataTrigger
        self.openLinkTrigger = input.openLinkTrigger
    }
    
    //MARK: - Input to output
    func transform() -> MovieDetailViewModelOutput {
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
                guard let self = self else { return 0 }
                return self.movieId
            }
            .flatMap { [unowned self] id in
                return self.detailService.getDetails(movieId: id)
            }
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isLoading.accept(false)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.onError.accept(error)
                self.isLoading.accept(false)
            })
            .subscribe(onNext: { [weak self] movie in
                guard let self = self else { return }
                self.data.accept([.detail(movie), .list(movie.cast)])
            })
            .disposed(by: disposeBag)
        
        openLinkTrigger
            .asObservable()
            .subscribe(onNext: { [weak self] key in
                guard let self = self else { return }
                let url = self.detailService.createTrailerUrl(key: key)
                if UIApplication.shared.canOpenURL(url) {
                     UIApplication.shared.open(url, options: [:], completionHandler: nil)
                 }
            })
            .disposed(by: disposeBag)
        
        return MovieDetailViewModelOutput(data: self.data.asDriver(),
                                          isLoading: self.isLoading.asDriver(),
                                          onError: self.onError.asDriver(onErrorDriveWith: .never()))
    }
}
