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
                                            detailService: MockDetailApi(scheduler: scheduler),
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
}
