//
//  PersonDetailViewModelTest.swift
//  MoviesTests
//
//  Created by Ayşenur Bakırcı on 20.10.2021.
//

import XCTest
import RxSwift
import RxTest
import RxCocoa
import RxBlocking
@testable import Movies

class PersonDetailViewModelTest: XCTestCase {
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        scheduler = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testLoading() throws {
        
        let observer = scheduler.createObserver(Bool.self)
        
        let loadTrigger = scheduler.createHotObservable([.next(10, ())])
        let inputs = PersonDetailViewModelInput(personId: 2535,
                                            detailService: MockDetailApi(),
                                            loadDataTrigger: loadTrigger.asDriver(onErrorDriveWith: .never()))
        let outputs = personDetailViewModel(input: inputs)
        
        outputs
            .isLoading
            .drive(observer)
            .disposed(by: disposeBag)
        
        outputs
            .data
            .drive()
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(observer.events, [.next(0, false), .next(10, true), .next(10, false)])
    }
    
    func testData() throws {
        
        let observer = scheduler.createObserver([PersonViewSections].self)
        
        let loadTrigger = scheduler.createHotObservable([.next(10, ())])
        let inputs = PersonDetailViewModelInput(personId: 2535,
                                            detailService: MockDetailApi(),
                                            loadDataTrigger: loadTrigger.asDriver(onErrorDriveWith: .never()))
        let outputs = personDetailViewModel(input: inputs)
        
        outputs
            .data
            .drive(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        for i in 0...1 {
            switch observer.events.last?.value.element?[i] {
            case .detail(let detail):
                XCTAssertEqual(detail.name, "Vivica A. Fox")
            case .list(let list):
                XCTAssertEqual(list.first?.title, "Two Can Play That Game")
            case .none:
                XCTFail("Data is empty.")
            }
        }
    }
    
    func testOpenDetailPage() throws {
        
        let observer = scheduler.createObserver(MovieDetailViewController.self)
        
        let openTrigger = scheduler.createHotObservable([.next(10, 0)])
        let inputs = PersonDetailViewModelInput(personId: 2535,
                                            detailService: MockDetailApi(),
                                            openMovieTrigger: openTrigger.asDriver(onErrorDriveWith: .never()))
        let outputs = personDetailViewModel(input: inputs)
        
        outputs
            .openMovieDetailController
            .drive(observer)
            .disposed(by: disposeBag)

        scheduler.start()
        XCTAssertFalse(observer.events.isEmpty)
    }
}
