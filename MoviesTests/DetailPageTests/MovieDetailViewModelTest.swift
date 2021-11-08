//
//  MovieDetailViewModelTest.swift
//  MoviesTests
//
//  Created by Ayşenur Bakırcı on 20.10.2021.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
@testable import Movies

class MovieDetailViewModelTest: XCTestCase {
    
    var loadData = PublishSubject<Void>()
    var openPersonDetailPage = PublishSubject<Int>()
    var openMovieTrailer = PublishSubject<String>()
    var sut: MovieDetailViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        let inputs = MovieDetailViewModelInput(movieId: 839436,
                                               detailService: MockDetailApi(),
                                           loadDataTrigger: loadData.asDriver(onErrorDriveWith: .never()),
                                           openPersonTrigger: openPersonDetailPage.asDriver(onErrorDriveWith: .never()),
                                           openLinkTrigger: openMovieTrailer.asDriver(onErrorDriveWith: .never()))
        sut = MovieDetailViewModel(input: inputs)
    }

    override func tearDownWithError() throws {
        sut = nil
        disposeBag = nil
        scheduler = nil
        super.tearDown()
    }
    
    func testLoading() throws {
        let output = sut.transform()
        let loading = scheduler.createObserver(Bool.self)
        
        output
            .isLoading
            .drive(loading)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: loadData)
            .disposed(by: disposeBag)
        
        scheduler.start()

        XCTAssertEqual(loading.events, [.next(0, false), .next(10, true), .next(10, false)])
    }
    
    func testData() throws {
        let output = sut.transform()
        let data = scheduler.createObserver([MovieViewSections].self)
        
        output
            .data
            .drive(data)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: loadData)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        for i in 0...1 {
            switch data.events.last?.value.element?[i] {
            case .detail(let detail):
                XCTAssertEqual(detail.title, "Dragon Fury")
            case .list(let cast):
                XCTAssertEqual(cast.first?.name, "Nicola Wright")
            case .none:
                XCTFail("Value is empty")
            }
        }
    }
    
    func testOpenDetailPage() throws {
        let output = sut.transform()
        let openTrigger = scheduler.createObserver(PersonDetailViewController.self)
        
        output
            .openMovieDetailController
            .drive(openTrigger)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, 0)])
            .bind(to: openPersonDetailPage)
            .disposed(by: disposeBag)
        
        scheduler.start()
        XCTAssertFalse(openTrigger.events.isEmpty)
    }
}
