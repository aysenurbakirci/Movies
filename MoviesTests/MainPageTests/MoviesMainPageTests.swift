//
//  MoviesMainPageTests.swift
//  MoviesTests
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import Movies

class MoviesMainPageTests: XCTestCase {
    
    var sut: MainViewModel?
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        sut = MainViewModel(mainViewService: MockMainApi())
        sut?.loadData.onNext(())
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
//    func testGetData() throws {
//
//        let data = scheduler.createObserver([Section].self)
//
//        sut?.data
//            .bind(to: data)
//            .disposed(by: disposeBag)
//
//        scheduler.createColdObservable([.next(5, ())])
//            .bind(to: sut!.loadData)
//            .disposed(by: disposeBag)
//
//        scheduler.start()
//
//    }
    
    func testNumberOfPages() throws {
        
        scheduler.createColdObservable([.next(1, ()), .next(5, ()), .next(8, ())])
            .bind(to: sut!.loadData)
            .disposed(by: disposeBag)
        
        scheduler.start()
        XCTAssertEqual(sut!.nextPage, 5)
    }
}
