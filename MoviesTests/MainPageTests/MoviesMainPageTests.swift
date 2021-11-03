//
//  MoviesMainPageTests.swift
//  MoviesTests
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import XCTest
import RxSwift
import RxTest
@testable import Movies

class MoviesMainPageTests: XCTestCase {
    
    var sut: MainViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        sut = MainViewModel(mainViewService: MockMainApi(scheduler: scheduler))
    }
    
    override func tearDownWithError() throws {
        sut = nil
        disposeBag = nil
        scheduler = nil
        super.tearDown()
    }
    
    func testNumberOfPages() throws {
        
        scheduler.createColdObservable([.next(0, ()), .next(100, ())])
            .bind(to: sut.loadData)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(sut.nextPage, 3)
    }
}

extension TestScheduler {
    /**
     Creates a `TestableObserver` instance which immediately subscribes to the `source`
     */
    func record<O: ObservableConvertibleType>(
        _ source: O,
        disposeBag: DisposeBag
    ) -> TestableObserver<O.Element> {
        let observer = self.createObserver(O.Element.self)
        source
            .asObservable()
            .bind(to: observer)
            .disposed(by: disposeBag)
        return observer
    }
}
